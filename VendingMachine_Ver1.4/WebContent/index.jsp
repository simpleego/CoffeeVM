<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>믹스커피/캔음료 자판기</title>
<style>
    * { margin: 0px; padding: 0px; }

    h1 {color: #993300;}

    form {
        width: 700px;
        margin: 10px auto;
        background-color: #fff9e6;
        border: 5px solid #b32d00;
        border-radius: 5%;
        padding: 5px 30px 5px 30px;
    }

    table { 
    	width: 100%; 
    	padding: 10px;
    }

    td { text-align: center; }
    
     #coins {
     	border: 1px solid #ccc;
     	padding: 10px;  
     }

    #coins td input {
        width: 80px;
        padding: 5px;
        cursor: pointer;
    }

    #menu td input {
        width: 100px;
        cursor: pointer;
        padding: 5px;
    }

    #customers {
        font-family: Arial, Helvetica, sans-serif;
        border-collapse: collapse;
        width: 100%;
    }

    #customers td, #customers th {
        width: 33.333%;
        padding: 10px;
    }

    #customers th {
        padding-top: 12px;
        padding-bottom: 12px;
        background-color: #04AA6D;
        color: white;
    }

    #coinInput, #returnCoin { 
    	text-align: right;
    	padding: 5px;
    }

    #menu {
        border: 1px solid #999;
    }

    #coffeeOut {
    	padding-top: 30px;
    	height: 200px;
        background-image: url("image/coffeeOut.png");
        background-repeat: no-repeat;
    }

    #canOut img {
        -webkit-animation-name: animation_move;
        -webkit-animation-duration: 1.5s;
        -webkit-animation-timing-function: linear;
        -webkit-animation-fill-mode: both
    }

    #canOut div {
        margin-top: 180px;
        padding-top: 60px;
        width: 380px;
        height: 50px;
        overflow-y: scroll;
        background-image: url("image/canOut.png");
        background-repeat: no-repeat;
    }

    @-webkit-keyframes animation_scale {
        0% {
            -webkit-transform: translateX(100px) translateY(100px) scale(0.25);
            opacity: 0;
        }

        1 % {
            opacity: 1;
        }

        100 % {
            -webkit-transform: translateX (0px) translateY (0px) scale (1);
        }
    }

    @-webkit-keyframes animation_move {
        0% {
            -webkit-transform: translateX(0px) translateY(-50px) scale(1);
        }

        50 % {
            -webkit-transform: translateX (0px) translateY (0px) scale (1);
        }

        100 % {
            -webkit-transform: translateX (-100px) translateY (0px) scale (1);
        }
    }
#loadCount {
	display: none;
}
</style>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script>
$(document).ready(function() {
	let canCount = '<c:out value='${canCount}'/>';
	if (canCount.length === 0) {
		init();
	}		
});		
		
function init() {
	$.ajax({
		type : 'get',
		traditional: true,	
		async : false, //false가 기본값임 - 비동기
		url : 'http://localhost:8088/vm',
		dataType: "text",
		success : function(data, textStatus) {
            let canCount = data.split(",");  
			for(var i = 0 ; i < canCount.length ; i++){
			 	$("#canBox span").eq(i).text(canCount[i]);
			}			 
		},
		error : function(data, textStatus) {
			console.log('error');
		}
	}) //ajax	
}		
		
</script>
</head>

<body>
    <form action="vm" method="post">
        <table id="customers">
            <tr>
                <td colspan="3">
                    <h1>믹스 커피 자판기</h1>
                </td>
            </tr>
            <tr class="coffeeBox">
                <td><img src="image/milkOut.png" height=80px> (300원)</td>
                <td><img src="image/creamOut.png" height=80px> (300원)</td>
                <td><img src="image/blackOut.png" height=80px> (200원)</td>
            </tr>
            <tr class="coffeeBox" id="menu">
                <td><input type="submit" name="menu" ${ empty btnMilk ? 'disabled' : '' } value="밀크커피"></td>
                <td><input type="submit" name="menu" ${ empty btnCream ? 'disabled' : '' } value="프림커피"></td>
                <td><input type="submit" name="menu" ${ empty btnBlack ? 'disabled' : '' } value="블랙커피"></td>
            </tr>
            <tr class="canBox">
                <td><img src="image/canCola.png"> (500원)</td>
                <td><img src="image/canFanta.png"> (600원)</td>
                <td><img src="image/canCider.png"> (700원)</td>
            </tr>
            <tr class="coffeeBox" id="menu">
                <td><input type="submit" name="canMenu" ${ empty btnCola ? 'disabled' : '' } value="콜라"></td>
                <td><input type="submit" name="canMenu" ${ empty btnFanta ? 'disabled' : '' } value="환타"></td>
                <td><input type="submit" name="canMenu" ${ empty btnCider ? 'disabled' : '' } value="사이다"></td>
            </tr>
            <tr class="canBox" id="canBox">               
                <td>잔량 :<span> ${ empty canCount[0] ? '0':canCount[0] }</span><br></td>
                <td>잔량 :<span>${ empty canCount[1] ? '0':canCount[1] }</span><br></td>
                <td>잔량 :<span>${ empty canCount[2] ? '0':canCount[2] }</span><br></td>               
            </tr>

            <tr>
                <td>잔액 : 
                <input id="coinInput" type="text" disabled value="${ empty balence ? '0':balence }">원
                </td>
                <td colspan="2">반환금액 : <input id="returnCoin" type="text" disabled value="${return_ }">원
                </td>
            </tr>

            <tr id="coins">
                <td colspan="3">
                	<input id="coin500" type="submit" name="coin" value="500"> 
                	<input type="submit" name="coin" value="100"> 
                    <input type="submit" name="coin" value="50">
                    <input type="submit" name="coin" value="10">
                    <input type="submit" name="return" value="동전반환"> 
                </td>
                <td>
                	<input type="submit" name="admin" value="관리자">
                </td>
            </tr>
            <tr>
            	<td>            	
            	</td><!-- 빈공간을 위한 태그  -->
            </tr>
            
            <tr>
                <td id="coffeeOut">
                    <c:if test="${not empty coffee}">
                        <img src="image/${coffee}.png" height="110px" />
                    </c:if>
                </td>
                <td colspan=2 id="canOut">
                	
                    <div contentEditable="true">
                        <c:if test="${canList != null}">
                            <c:forEach var="can" items="${canList}">
                                <img src="image/${can}.png" />
                            </c:forEach>
                        </c:if>
                    </div>
                </td>
            </tr>
        </table>
    </form>

</body>
</html>