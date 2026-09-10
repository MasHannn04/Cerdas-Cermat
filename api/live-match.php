<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/functions.php';

header('Content-Type: application/json');

$match = current_active_match();

if (!$match) {
    json_response([
        'ok' => true,
        'has_active_match' => false,
        'event' => null,
        'match' => null,
    ]);
}

json_response([
    'ok' => true,
    'has_active_match' => true,
    'event' => [
        'id' => (int) $match['event_id'],
        'name' => $match['event_name'],
        'location' => $match['location'],
        'status' => $match['event_status'],
    ],
    'match' => [
        'id' => (int) $match['id'],
        'status' => $match['status'],
        'status_label' => status_label($match['status']),
        'current_question' => (int) $match['current_question'],
        'round_name' => $match['round_name'],
        'team_count' => (int) $match['team_count'],
        'scoreboard_url' => '/scoreboard.php?match_id=' . (int) $match['id'],
        'buzzer_url' => '/buzzer.php?match_id=' . (int) $match['id'],
    ],
]);
