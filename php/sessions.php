<?php 
/**
 * @file Пользовательская обработка сессий.
 */
session_set_save_handler(
 's_open',
 's_close',
 's_read',
 's_write',
 's_destroy',
 's_gc');

function s_open($path, $name) {
  // пусть запуск s_gc будет в 100% случаев при старте сессии - session_start
  // формула gc_probability/gc_divisor = 1/1
  ini_set('session.gc_divisor', 1);
  // установим время жизни значения сессии в 20 секунд
  ini_set('session.gc_maxlifetime', 20);
  // выставим serialize_handler
  ini_set('session.serialize_handler', 'igbinary');
  return true;
}

function s_read($sid) {
  $spath = ini_get('session.save_path') . 'sess_' . $sid;
  if (!file_exists($spath)) {
    return '';
  }
  $session = file_get_contents($spath);
  // добавляем значение в сессию
  $_S = igbinary_unserialize($session);
  $_S['b'] = 2;
  $session = igbinary_serialize($_S);
  
  if(!empty($session)) {
    return $session;
  }
  return '';
}

function s_write($sid , $data) {
  $spath = ini_get('session.save_path') . 'sess_' . $sid;
  return file_put_contents($spath, $data) ? true : false;
}

function s_destroy($sid) {
  $spath = ini_get('session.save_path') . 'sess_' . $sid;
  return unlink($spath);
}

function s_close() {
  return true;
}

function s_gc($lifetime){
  // $lifetime === ini_get('session.gc_maxlifetime')
  // call after s_read and before s_write
  $spath = ini_get('session.save_path') . 'sess_' . session_id();
  $delta = time() - filemtime($spath);
  if ($delta > $lifetime) {
    unset($_SESSION['b']);
  }
  return true;
}

session_start();              // callbacks: s_open -> s_read
$_SESSION['a'] = 1;           // in memory
if (!isset($_SESSION['b'])) { // s_gc in action
  print 'Delete session "b" value by s_gc.';
}
//session_destroy();          // callback: s_destroy
//session_write_close();      // callback: s_write -> s_close
