<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Insert title here</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="6" class="oikealle"><span id="takaisin">Takaisin listaukseen</span></th>
			</tr>		
			<tr>
				<th>Nimi</th>
				<th>Merkki</th>
				<th>Pituus</th>
				<th>Leveys</th>
				<th>Hinta</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="nimi" id="nimi"></td>
				<td><input type="text" name="merkkimalli" id="merkkimalli"></td>
				<td><input type="text" name="pituus" id="pituus"></td>
				<td><input type="text" name="leveys" id="leveys"></td> 
				<td><input type="text" name="hinta" id="hinta"></td> 
				<td><input type="submit" id="tallenna" value="Lisää"></td>
			</tr>
		</tbody>
	</table>
</form>
<span id="ilmo"></span>
</body>
<script>
$(document).ready(function(){     //jqueryn aloitustagi
	$("#takaisin").click(function(){  //kun takaisin tekstiä painetaan siirrytään takaisin listaaveneet.jsp funktioon
		document.location="listaaveneet.jsp";
	});
	$("#tiedot").validate({						
		rules: {
			nimi:  {
				required: true,
				minlength: 1,
				maxlength: 50
			},	
			merkkimalli:  {
				required: true,
				minlength: 1,
				maxlength: 50
			},
			pituus:  {
				required: true,
				number:	  true,
				min:	   1,
				max:	   200,
				minlength: 1,
				maxlength: 5
			},	
		
			leveys:  {
				required: true,
				number:	  true,
				min:	   1,
				max:	   20,
				minlength: 1,
				maxlength: 5
			},
			hinta:  {
				required: true,
				number:   true,
				min:       1,
				max:       100000,
				minlength: 1,
				maxlength: 6
			}	
		},
		messages: {
			nimi: {     
				required:  "Puuttuu",
				minlength: "Anna nimi 1-50 merkkiä",
				maxlength: "Anna nimi 1-50 merkkiä"
			},
			merkkimalli: {
				required:  "Puuttuu",
				minlength: "Anna nimi 1-50 merkkiä",
				maxlength: "Anna nimi 1-50 merkkiä"
				
			},
			pituus: {
				required:  "Puuttuu",
				number:	   "Anna lukuarvo",
				min:	   "Anna arvo välillä 1-200",
				max:	   "Anna arvo välillä 1-200",
				minlength: "Liian pieni arvo",
				maxlength: "Liian suuri arvo"
			},
			leveys: {
				required:  "Puuttuu",
				number:	   "Anna lukuarvo",
				min:	   "Anna arvo välillä 1-20",
				max:	   "Anna arvo välillä 1-20",
				minlength: "Liian pieni arvo",
				maxlength: "Liian suuri arvo"
			},
			hinta: {
				required:  "Puuttuu",
				number:	   "Anna luku",
				min:	   "Anna kokonaisluku välillä 1-100000",
				max:	   "Anna kokonaisluku välillä 1-100000",
				minlength: "Liian pieni arvo",
				maxlength: "Liian suuri arvo"
			}
		},			
		submitHandler: function(form) {	
				lisaaTiedot();//validointi onnistuneet läpi, niin kutsu lisaatiedot
		}		
	}); 
	$("#nimi").focus(); 
});
//funktio tietojen lisäämistä varten. Kutsutaan backin POST-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//POST /veneet/
function lisaaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray());//otetaan tiedot taulukon tiedot, muutetaan lomakkeen tiedot json-stringiksi(scripts/main.js) ja viedään servletille Restiin 
	console.log(formJsonStr);
	$.ajax({url:"veneet", data:formJsonStr, type:"POST", dataType:"json", success:function(result) {     
		if(result.response==0){ //result on joko {"response:1"} tai {"response:0"} 
    	$("#ilmo").html("Veneen lisääminen epäonnistui.");
    }else if(result.response==1){			
    	$("#ilmo").html("Veneen lisääminen onnistui.");
    	$("#nimi", "#merkkimalli", "#pituus", "#leveys", "#hinta").val("");//tyhjentää ruudulta tiedot, ei tyhjennetä painonappia
		}
	}});	
}
</script>
</html>