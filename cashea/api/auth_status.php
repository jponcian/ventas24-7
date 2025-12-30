<?php
require '../db.php';
header('Content-Type: application/json');
if (isset($_SESSION['user_id'])) {
    $uname = isset($_SESSION['username']) ? $_SESSION['username'] : null;
    echo json_encode(array('ok' => true, 'user_id' => $_SESSION['user_id'], 'username' => $uname));
} else {
    echo json_encode(array('ok' => false));
}
