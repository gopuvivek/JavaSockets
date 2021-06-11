<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<title>Patient Portal</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	<link rel="stylesheet" href="css/styles.css">
</head>
<body>
	<div class="header text-center mr-auto ml-auto mt-3">
		<h3>Hello <%= request.getParameter("username") %>!</h3>
	</div>
	<div class="container mt-5">
		<div class="row">
			<div class="card mr-auto ml-auto" style="width: 18rem;">
				<div class="card-body">
					<h6 class="card-text">Please enter the following details</h6>
				  <label for="vital" class="col-form-label">Oxygen Saturation Level</label>
					<div class="col-sm-6 mb-2">
					  <input type="number" class="form-control" id="vital" name="vital" required>
					</div>
					<div class="text-center">
						<button onclick="sendVitals();" class="btn btn-pass">Submit</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="container">
		
		<br /><br />
		<table id="example" class="table table-pass">
			<thead>
				<tr>
					<th>Doctor</th>
					<th>Medicine</th>
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
		websocket.onmessage=function processVital(vital){
			var jsonData=JSON.parse(vital.data);
			console.log(jsonData);
			if(jsonData.message!=null)
			{
				var details=jsonData.message.split(',');
				console.log(details);
				var row=document.getElementById('example').insertRow();
				if(details.length>2)
				{
					row.innerHTML="<td>"+details[0]+"</td><td>"+details[1]+"</td><td>"+details[2]+"</td>";		
				}
				else
				{
					alert(details[0]+" has summoned an ambulance");
					row.innerHTML="<td>"+details[0]+"</td><td>NA</td><td>"+details[1]+"</td>";		
				}
			}
		}
		function sendVitals()
		{
			websocket.send(vital.value);
			vital.value="";
		}
	</script>
</body>
</html>