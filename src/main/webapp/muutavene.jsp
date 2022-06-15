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
<title>Venetietojen muutos</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="7" class="oikealle"><span id="takaisin">Takaisin listaukseen</span></th>
			</tr>		
			<tr>
				
				<th>Nimi</th>
				<th>Merkki</th>
				<th>Pituus</th>
				<th>Leveys</th>
				<th>Hinta</th>
				<th>Hallinta</th>
				
			</tr>
		</thead>
		<tbody>
			<tr>
				
				<td><input type="text" name="nimi" id="nimi"></td>
				<td><input type="text" name="merkkimalli" id="merkkimalli"></td>
				<td><input type="text" name="pituus" id="pituus"></td>
				<td><input type="text" name="leveys" id="leveys"></td> 
				<td><input type="text" name="hinta" id="hinta"></td> 
				<td><input type="submit" id="tallenna" value="Hyv�ksy"></td>
			</tr>
		</tbody>
		
	</table>
		<input type="hidden" name="tunnus" id="tunnus">
</form>
<span id="ilmo"></span>
</body>
<script>
$(document).ready(function(){ 
	$("#takaisin").click(function(){
		document.location="listaaveneet.jsp";
	});
	 $("#nimi").focus();
//Haetaan muutettavan veneen tiedot. Kutsutaan backin GET-metodia ja v�litet��n kutsun mukana muutettavan tiedon id
//GET /autot/haeyksi/tunnus
	var tunnus = requestURLParam("tunnus"); //Funktio l�ytyy scripts/main.js 	
	$.ajax({url:"veneet/haeyksi/"+tunnus, type:"GET", dataType:"json", success:function(result){	
		$("#hinta").val(result.hinta);	
		$("#merkkimalli").val(result.merkkimalli);
		$("#leveys").val(result.leveys);
		$("#nimi").val(result.nimi);	
		$("#pituus").val(result.pituus);
		$("#tunnus").val(result.tunnus);			
	 }});
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
					minlength: "Anna nimi 1-50 merkki�",
					maxlength: "Anna nimi 1-50 merkki�"
				},
				merkkimalli: {
					required:  "Puuttuu",
					minlength: "Anna nimi 1-50 merkki�",
					maxlength: "Anna nimi 1-50 merkki�"
					
				},
				pituus: {
					required:  "Puuttuu",
					number:	   "Anna lukuarvo",
					min:	   "Anna arvo v�lill� 1-200",
					max:	   "Anna arvo v�lill� 1-200",
					minlength: "Liian pieni arvo",
					maxlength: "Liian suuri arvo"
				},
				leveys: {
					required:  "Puuttuu",
					number:	   "Anna lukuarvo",
					min:	   "Anna arvo v�lill� 1-20",
					max:	   "Anna arvo v�lill� 1-20",
					minlength: "Liian pieni arvo",
					maxlength: "Liian suuri arvo"
				},
				hinta: {
					required: "Puuttuu",
					number:	   "Anna luku",
					min:	   "Anna kokonaisluku v�lill� 1-100000",
					max:	   "Anna kokonaisluku v�lill� 1-100000",
					minlength: "Liian pieni arvo",
					maxlength: "Liian suuri arvo"
				}
			},			
			submitHandler: function(form) {	
				
				paivitaTiedot();//validointi onnistuneet l�pi, niin kutsu paivitaTiedot
			}		
		}); 
		$("#nimi").focus(); 
});
//funktio tietojen p�ivitt�mist� varten. Kutsutaan backin PUT-metodia ja v�litet��n kutsun mukana uudet tiedot json-stringin�.
//PUT /veneet/
function paivitaTiedot(){	
		var formJsonStr = formDataJsonStr($("#tiedot").serializeArray());//otetaan  taulukon tiedot, muutetaan lomakkeen tiedot json-stringiksi(scripts/main.js) ja vied��n servletille Restiin 
		console.log(formJsonStr);
		$.ajax({url:"veneet", data:formJsonStr, type:"PUT", dataType:"json", success:function(result) {     
			if(result.response==0){ //result on joko {"response:1"} tai {"response:0"} 
	    		$("#ilmo").html("Veneen p�ivitt�minen ep�onnistui.");
	    	}else if(result.response==1){			
	    		$("#ilmo").html("Veneen p�ivitt�minen onnistui.");
	    		$("#nimi", "#merkkimalli", "#pituus", "#leveys", "#hinta").val("");//tyhjent�� ruudulta tiedot, ei tyhjennet� painonappia
			}
		}});	
}

</script>
</html>