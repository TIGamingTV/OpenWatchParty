use super::constants::{MAX_READY_WAIT_MS, PLAY_SCHEDULE_MS};
use crate::messaging::broadcast_to_room;
use crate::types::{Clients, Room, Rooms, WsMessage};
use crate::utils::now_ms;
use std::time::Duration;
use tokio::time::sleep;

pub(super) fn all_ready(room: &Room) -> bool {
    room.ready_clients.len() >= room.clients.len()
}

pub(super) async fn broadcast_scheduled_play(
    room: &mut Room,
    clients: &Clients,
    position: f64,
    target_server_ts: u64,
) {
    room.state.position = position;
    room.state.play_state = "playing".to_string();
    let msg = WsMessage {
        msg_type: "player_event".to_string(),
        room: Some(room.room_id.clone()),
        client: None,
        payload: Some(serde_json::json!({
            "action": "play",
            "position": position,
            "target_server_ts": target_server_ts
        })),
        ts: now_ms(),
        server_ts: Some(target_server_ts),
    };
    let locked_clients = clients.read().await;
    broadcast_to_room(room, &locked_clients, &msg, None);
}

pub(super) fn schedule_pending_play(
    room_id: String,
    created_at: u64,
    clients: Clients,
    rooms: Rooms,
) {
    tokio::spawn(async move {
        sleep(Duration::from_millis(MAX_READY_WAIT_MS)).await;
        let mut locked_rooms = rooms.write().await;
        if let Some(room) = locked_rooms.get_mut(&room_id) {
            let pending = match room.pending_play.clone() {
                Some(pending) if pending.created_at == created_at => pending,
                _ => return,
            };
            room.pending_play = None;
            let target_server_ts = now_ms() + PLAY_SCHEDULE_MS;
            broadcast_scheduled_play(room, &clients, pending.position, target_server_ts).await;
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_helpers;
    use std::collections::HashSet;

    #[test]
    fn all_ready_true() {
        let mut room = test_helpers::create_room("r1", "host");
        room.clients = vec!["host".to_string(), "guest".to_string()];
        room.ready_clients = HashSet::from(["host".to_string(), "guest".to_string()]);
        assert!(all_ready(&room));
    }

    #[test]
    fn all_ready_false() {
        let mut room = test_helpers::create_room("r1", "host");
        room.clients = vec!["host".to_string(), "guest".to_string()];
        room.ready_clients = HashSet::from(["host".to_string()]);
        assert!(!all_ready(&room));
    }

    #[test]
    fn all_ready_empty_room() {
        let mut room = test_helpers::create_room("r1", "host");
        room.clients.clear();
        room.ready_clients.clear();
        assert!(all_ready(&room));
    }
}
