<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
 
pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<title>Portfolio</title>
<meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>


<body ng-app="myApp">

<div ng-controller="myCtrl">
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">StockWorld</a>
    </div>
    <ul class="nav navbar-nav">
      <li><a href="#" ng-click="getHome()">Home</a></li>
    </ul>
    <ul class="nav navbar-nav">
      <li><a href="#" ng-click="getPortfolio()">Portfolio</a></li>
    </ul>
  </div>
</nav>
  
	<div class="container">
		<div ng-show="cClass == 1">
			<div class="input-group">
    			<span class="input-group-addon">Symbol</span>
    			<input ng-model="sym" type="text" class="form-control" name="msg" placeholder="Enter the Symbol you want to search..">
 			</div>
 			</br>
  			<p><button type="button" class="btn btn-primary" ng-click="searchSymbol()">Search</button></p>
  			<p>{{validationText1}}</p>
  			<p><label>Company Name: {{name}}</label></p>
  			<p><label>Stock Symbol: {{symbol}}</label></p>
  			<p><label>Last Traded Price: {{price}}</label></p>
  			<div class="input-group">
    			<span class="input-group-addon">No Of Stocks</span>
  				<input ng-model="noStocks" type="text" class="form-control" name="msg" placeholder="Enter the no of Stocks..">
			</div>
			</br>
  			<p><button type="button" class="btn btn-primary" ng-click="addToPortfolio()">Add To Portfolio</button></p>
			<p>{{validationText2}}</p>
		</div>
		
		
		<div ng-show="cClass == 2">
		<p>Portfilio will load here</p>
		
		<table class="table table-hover" id="stockTable">
			<thead>
				<tr>
					<th>Name</th>
					<th>Symbol</th>
					<th>Last Traded Price</th>
					<th></th>
					<th>Number Of Stocks</th>
					<th>Total Amount</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
  				<tr ng-repeat="x in stocks">
		    		<td>{{ x.name }}</td>
		    		<td>{{ x.symbol }}</td>
		    		<td>0</td>
		    		<td><img  border="0" src="<%=request.getContextPath()%>/resources/images/Arrow_Up.png" width="30" height="22"></td>
		    		<td>{{ x.numberOfStocks }}</td>
		    		<td>0</td>
		    		<td><button type="button" class="btn btn-primary" ng-click="deleteFromPortfolio(x.symbol)">Remove from Portfolio</button></td>
 				</tr>
 			</tbody>
		</table>
		</div>
	</div>
</div>
<input type="hidden" id="hdninput" value=0;>
<script>
var count=1;
var app = angular.module('myApp', []);
  app.controller('myCtrl', ['$scope','$http', function($scope,$http) {
    $scope.validationText1 = "";
    $scope.name = "";
    $scope.symbol = "";
    $scope.price = "";
    $scope.noStocks = "";
    $scope.count = 0;
    $scope.cClass=1;	
    
    $scope.searchSymbol = function() {
    	//restful 
    var url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22"+$scope.sym+"%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&";
	$http.get(url).success(function(response) { //ajax
	
		var companyName=response.query.results.quote.Name
		if(companyName!=null){
			$scope.name=response.query.results.quote.Name;
			$scope.symbol=response.query.results.quote.Symbol;
			$scope.price=response.query.results.quote.LastTradePriceOnly;
			$scope.validationText1 = "";
			$scope.validationText2 = "";
		}else{
			$scope.validationText1 = "Enter a valid value";
		}
   });  
  };
  
  $scope.addToPortfolio = function() {
	  if($scope.noStocks==""){
		  $scope.noStocks=0;
	  }
	  var num = parseInt($scope.noStocks, 10); 
	  $scope.validationText2 = "";
	  if(isNaN(num)){
		  $scope.validationText2 = "Enter a valid number for number of stocks";
	  }else{
	  var url = "http://localhost:8080/StockWorld/addToPortfolio?name="+$scope.name+"&ltp="+$scope.price+"&symbol="+$scope.symbol+ "&noOfStocks="+$scope.noStocks;
		$http.get(url).success(function(response) {
			var data=response.inserted;
			if(data=='yes'){
				alert("Data Inserted");
			}else if(data=='more than 5'){
				alert("You cannot add more than 5 companies")
			}else{
				alert("If you want to update, first delete from portfolio and insert again");	
			}
			
	   });  
	  }
	  };
  $scope.deleteFromPortfolio = function(sym) {
		var url = "http://localhost:8080/StockWorld/deleteFromPortfolio?symbol="+sym;
			$http.get(url).success(function(response) {
				var index = -1;		
				var stockArr = eval( $scope.stocks );
				for( var i = 0; i < stockArr.length; i++ ) {
					if( stockArr[i].symbol === sym ) {
						index = i;
						break;
					}
				}
				if( index === -1 ) {
					alert( "Something gone wrong" );
				}
				$scope.stocks.splice( index, 1 );		
		   });  
		  };
  
  $scope.getPortfolio = function() {
  	$scope.cClass=2;
  		var url = "http://localhost:8080/StockWorld/getPortfolio";
			$http.get(url).success(function(response) {
				$scope.stocks=response;
		
   });  

	if(count==1){
		setInterval(function(){
			$scope.updateStockPrice();
		}, 5000);
		count=2;
	}
  };
  
  $scope.getHome = function(item) {
  	$scope.cClass=1;
  	$scope.sym="";
  	$scope.name = "";
    $scope.symbol = "";
    $scope.price = "";
    $scope.noStocks = "";
  };
  
  $scope.updateStockPrice = function(){
	  stockArr = eval( $scope.stocks );
		for( var i = 0; i < stockArr.length; i++ ) {
			var url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22"+$scope.stocks[i].symbol+"%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&";
			//document.getElementById("hdninput").value=i;
			$http.get(url).success(function(response) {
				var newPrice=response.query.results.quote.LastTradePriceOnly;
				//newPrice=newPrice;
				var sym=response.query.results.quote.Symbol;
				var allTR=document.getElementById("stockTable").getElementsByTagName("tbody")[0].getElementsByTagName("tr");
				for(var j=0; j<allTR.length;j++){
					if(allTR[j].getElementsByTagName("td")[1].innerHTML==sym){
						oldPrice=allTR[j].getElementsByTagName("td")[2].innerHTML
						if(oldPrice!=0){
						if(oldPrice>newPrice){
							allTR[j].getElementsByTagName("td")[3].getElementsByTagName("img")[0].src="/StockWorld/resources/images/Arrow_Down.png";
						}else{
							allTR[j].getElementsByTagName("td")[3].getElementsByTagName("img")[0].src="/StockWorld/resources/images/Arrow_Up.png";
						}
						}
						allTR[j].getElementsByTagName("td")[2].innerHTML=newPrice;
						var num=allTR[j].getElementsByTagName("td")[4].innerHTML;
						allTR[j].getElementsByTagName("td")[5].innerHTML=num*newPrice;
					}
				}
			});
		}
  };
  
}]);

</script>
</body>

</html>