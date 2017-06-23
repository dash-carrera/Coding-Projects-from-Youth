

while (1<2)
{
	var score = "";
	//$.get('/get-score',function(ret_score){score = ret_score.split("&");});
	p1score = score[0];
	p2score = score[1];
	console.log(p1score);
	console.log(p2score);
	$('#p1score').innerHTML=p1score;
	$('#p2score').innerHTML=p2score;
	setInterval(function(){console.log(1)},3000);
}

