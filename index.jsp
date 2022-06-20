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
        width: 600px;
        margin: 10px auto;
        background-color: #fff9e6;
        border: 10px solid #b32d00;
        border-radius: 5%;
        padding: 5px 30px 5px 30px;
    }

    table { width: 100%;padding: 10px; }

    td { text-align: center; }

    #coins td input {
        width: 50px;
        cursor: pointer;
    }

    #menu td input {
        width: 100px;
        cursor: pointer;
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
        text-align: left;
        background-color: #04AA6D;
        color: white;
    }

    #coinInput { padding: 5px; }

    .coffeeBox {
        border: 1px solid #999;
    }

    .canBox { border: 1px solid #cc3300; }

    #coffeeOut {
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
		//alert("cancount"+canCount)
			console.log("canCount");
			console.log(typeof(canCount));
		if (canCount.length === 0) {
			console.log("canCount-->");
			init();
		}		
	});
		
		
function init() {
	$.ajax({
		type : 'get',
		async : false, //false가 기본값임 - 비동기
		url : 'http://localhost:8080/vm',
		dataType : 'text',			
		success : function(data, textStatus) {
			console.log('sucess');
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
            <tr class="canBox">               
                <td>잔량 : ${ empty canCount[0] ? '0':canCount[0] }<br></td>
                <td>잔량 :${ empty canCount[1] ? '0':canCount[1] }<br></td>
                <td>잔량 :${ empty canCount[2] ? '0':canCount[2] }<br></td>               
            </tr>

            <tr>
                <td>잔액 : <input style="text-align: right" id="coinInput" type="text" disabled
                        value="${ empty balence ? '0':balence }">원
                </td>
                <td colspan="2">반환금액 : <input type="text" disabled value="${return_ }">원
                </td>
            </tr>

            <tr id="coins">
                <td colspan="4">
                	<input id="coin500" type="submit" name="coin" value="500"> 
                	<input type="submit" name="coin" value="100"> 
                    <input type="submit" name="coin" value="50">
                    <input type="submit" name="coin" value="10">
                    <input type="submit" name="return" value="동전반환"> 
                    <input type="submit" id="loadCount" /></td>
                </td>
            </tr>
            <tr>
                <td colspan="3">커피 출력</td>
            </tr>
            <tr>
                <td id="coffeeOut">
                    <c:if test="${coffee != null}">
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