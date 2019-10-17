<?php
if(isset($_REQUEST['url'])&&$_REQUEST['url']!='')
  {
  $urlyoutube=$_REQUEST['url'];
  
    echo'<div id="message">Url youtube : '.$urlyoutube.'<br>Veuillez patienter s.v.p. <br>Travail en cours.</div>';
    echo'<div id="message1" style="display:none">Recuperation et convertion en cours.</div>';
    echo'<div id="message2" style="display:none">Insertion dans airtime en cours.</div>';
    echo'<div id="message3" style="display:none">TERMINE.</div><hr>';
                
    echo'<script> document.getElementById("message1").style.display = "block"; </script>';
    ob_flush();
    flush();
    ob_flush();
    flush(); 
    
    exec("youtube-dl -x --audio-format mp3 -o /srv/airtime/uploads/youtube/'%(title)s'.'%(ext)s' ".$urlyoutube." --add-metadata -x 2>&1");
    
    echo'<script> document.getElementById("message2").style.display = "block"; </script>';
    ob_flush();
    flush();
    ob_flush();
    flush(); 
    
    exec("/usr/share/airtime/php/airtime_mvc/public/youtube-airtime/import-folder-of-tracks.sh 2>&1");
    
    echo'<script> document.getElementById("message3").style.display = "block"; </script>';
    ob_flush();
    flush();
    ob_flush();
    flush(); 
   }
   
if(!isset($REQUEST['form'])||isset($REQUEST['form'])&&$REQUEST['form']=='yes') {
?><form action='YT.php' methode=post >
  Url Youtube pour airtime : <input type=text value='' name=url >
  <input type=submit >
  </form>
  <?php
  }
