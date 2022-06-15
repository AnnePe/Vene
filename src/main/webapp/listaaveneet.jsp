<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Venekanta</title>
</head>
<body>
<table id="listaus" border="1"> 
	<thead>
		<tr>
			<th colspan="7" class="oikealle"><span id="uusiVene">Lisää uusi vene</span></th>
		</tr>	
		<tr>
			
			<th colspan="2" class="oikealle">Hakusana:</th>
			<th colspan="3" class="vasemmalle"><input type="text" id="hakusana"></th>
			<th colspan="2" class="vasemmalle"><input type="button" value="Hae" id="hakunappi"></th>
		</tr>
		<tr>
			<th class="vasemmalle">Tunnus</th>
			<th class="vasemmalle">Nimi</th>
			<th class="vasemmalle">Merkki</th>
			<th class="vasemmalle">Pituus</th>
			<th class="vasemmalle">Leveys</th>
			<th class="vasemmalle">Hinta</th>
			<th></th>
										
		</tr>
	</thead>
	<tbody>
	</tbody>
</table>

<script>
$(document).ready(function(){                         
	$("#uusiVene").click(function(){ 
		document.location="lisaavene.jsp";//ohjataan lisaavene.jsp sivulle
	});
	haeVeneet();
	$("#hakunappi").click(function(){
		haeVeneet();
    });
	$(document.body).on("keydown",function(event){
	    	if(event.which==13){
	    		haeVeneet();
	    	}
	 });
    $("#hakusana").focus();//viedään kursori hakusana kenttään, ajetaan kun sivu ladataan
});
function haeVeneet(){  
	$("#listaus tbody").empty();
	$.ajax({url:"veneet/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){ //Funktio palauttaa tiedot json-objektina  
		$.each(result.veneet, function(i, field){  //haetaan backendistä veneet ajaxilla @webservlet"veneet" Veneet servletissä  
        	var htmlStr;						  
        	htmlStr+="<tr id='rivi_"+field.tunnus+"'>";
        	htmlStr+="<td>"+field.tunnus+"</td>";
        	htmlStr+="<td>"+field.nimi+"</td>";
        	htmlStr+="<td>"+field.merkkimalli+"</td>";
        	htmlStr+="<td>"+field.pituus+"</td>";
        	htmlStr+="<td>"+field.leveys+"</td>";
        	htmlStr+="<td>"+field.hinta+"</td>";
        	htmlStr+="<td><a href='muutavene.jsp?tunnus="+field.tunnus+"'>Muuta</a>&nbsp;";  
        	htmlStr+="<span class='poista' onclick=poista("+field.tunnus+",'"+field.nimi+"')>Poista</span></td>"; 
        	htmlStr+="</tr>";
        	$("#listaus tbody").append(htmlStr);//elementin id=listaus lisätään tbody
        });	
				
	}});
};
//funktio tietojen poistamista varten. Kutsutaan backin DELETE-metodia.
//DELETE /veneet
function poista(tunnus, nimi){
	//console.log(tunnus);
	if(confirm("Poistetaanko vene " + tunnus +" "+ nimi+ "?")){
	$.ajax({url:"veneet/"+tunnus, type:"DELETE", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}
        if(result.response==0){
        	$("#ilmo").html("Veneen poisto epäonnistui.");
        }else if(result.response==1){
        	$("#rivi_"+tunnus).css("background-color", "red"); //Värjätään poistetun veneen rivi
        	alert("Veneen id:llä " + tunnus +" "+ nimi+" poisto onnistui.");
			haeVeneet();        	
		}
    }});
};

}
</script>
</body>
</html>