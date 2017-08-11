$(".titleAdd").click(function(){
/*	var htmlLi="<li>"+"<p>"+"111"+"</p>"+"<span>"+"</span>"+"</li>"
	$(this).before(htmlLi)
var downUpLeft = $(".titleTop-down .up-left").offset().left;//up-left距左距离
var downUpWidth = $(".titleTop-down .up-left").width();//up-left宽度
var downUpright = $(".titleTop-down .up-right").offset().left;//up-right距左距离
var distances = downUpright -(downUpLeft+downUpWidth);//up-left，up-right直接距离
var Width=downUpright-downUpLeft-50;
if(distances<=50){
	var Pp=$(".titleTop-down .up-left li").children("p");//获取p标签
	var Pwidth=Pp.width();//获取p标签宽度
	var LILenght=$(".titleTop-down .up-left li").length;//获取li长度
	var PNewWidth=Width/LILenght;
	$(".titleTop-down .up-left").css("width",Width+"px");
	Pp.css("width",+PNewWidth+"px");
		if($(".titleTop-down .up-left").width()==Width){
		$(".titleAdd").css({"position":"absolute","right":"-90"})
	}
}
*/
//alert("开发中，敬请期待")
})
/*添加左侧列表icon*/
$.each($('.index-titleLeft dd'),function(i){
	var className=$('.index-titleLeft dd').eq(i).attr('class');//获取类名
	if($(this).hasClass(className)){
		$(this).css("background-image","url(Images/"+$(this).attr('class')+".png)");//添加icon
	}
})

$(".informationTitle i").click(function(){
	//$(".information").toggleClass("ba");
    $(this).toggleClass("jia");
    $(this).parent().next("div").toggleClass("hide");
    $("#SearchFrameSet").remove();
    
})


var  informationWidth=$(".information").width();
var leftLenght=$(".information ").children(".left").length;
var leftWidth=100/leftLenght;
$(".information ").children(".left").width(leftWidth+"%");



