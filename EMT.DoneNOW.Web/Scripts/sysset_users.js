
$.each($(".ATTabControlTabRow td"),function(i){
   $(this).click(function(){
       $(this).addClass("Selected").siblings("td").removeClass("Selected");
       $(".C").eq(i).show().siblings(".C").hide();
   })
});