/*$(document).ready(function () {
  var hashValue = window.location.hash.substr(2);
  if(hashValue.length>0) {
    var classNumber = 0;
    var widthTimes = 0;
    var counter = 0;
    elements = $(".slide");

    elements.each(function()
    {
      if ($(this).attr('id') === hashValue) {
        classNumber = counter + 1;
        widthTimes = counter;
      }
      counter++;
    });

    $curContentDiv=$(".img-dragger div[data-content='content-"+ classNumber +"']");
    setTimeout(function(){
      $translate=$(window).width()*widthTimes;
      $(".img-dragger div.slide").removeClass("current");
      $curContentDiv.addClass("current");
      $(".handle").css("transform" ,"translate3d(-"+$translate+"px,0px,0px)");
      setTimeout(function(){
        $(".slide.current button.content-switch")[0].click();
        setTimeout(function(){
        },600);
      },40);

    },100);
  }
});
*/
