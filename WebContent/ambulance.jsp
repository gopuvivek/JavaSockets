<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<title>Ambulance Portal</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	<link rel="stylesheet" href="css/styles.css">
</head>
<body>
	<div class="container">
		<div class="header text-center mr-auto ml-auto mt-3">
			<h3>Ambulance Dashboard</h3>
			<label style="margin-top:30px;">You shall be notified when a patient requires ambulance</label>
		</div>
		
		<table id="example" class="table table-pass" style="margin-top:30px;">
			<thead>
				<tr>
					<th>Patient Name</th>
					<th>Phone</th>
					<th>Description</th>
				</tr>
			</thead>
			<tbody>
				<tr>
				</tr>
			</tbody>
		</table>
	</div>
	<script src="js/jquery.slim.min.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script>
		var websocket=new WebSocket("ws://localhost:8080/WebSocket/VitalCheckEndPoint");
		websocket.onmessage=function processMessage(message){
			var jsonData=JSON.parse(message.data);
			if(jsonData.message!=null)
			{
				var details=jsonData.message.split(',');
				var row=document.getElementById('example').insertRow();
				row.innerHTML="<td>"+details[0]+"</td><td>"+details[1]+"</td>"+"<td>"+details[2]+"</td>";
				alert(details[0]+" requires an ambulance");
			}
		}
	</script>
</body>
</html>