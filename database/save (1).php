<?php
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
// Check if decoding was successful
if ($data !== null) {
    $cid = addslashes(strip_tags($data['cid']));
    $name = addslashes(strip_tags($data['name']));
    $key = addslashes(strip_tags($data['key']));

if ($key != "your_key" or trim($name) == "")
    die("access denied");

$con=mysqli_connect("localhost","id21733850_user1", "khElena22@","id21733850_company");
// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

$sql = "insert into categories values ($cid, '$name')";
mysqli_query($con,$sql) or
    die ("can't add record");

echo "Record Added";
   
mysqli_close($con);
} else {
   // JSON decoding failed
   http_response_code(400); // Bad Request
   echo "Invalid JSON data";
}

?> 			