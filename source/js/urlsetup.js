$(document).ready(function () {
  var hashValue = window.location.hash.substr(1);
  if(hashValue.length>0) {
    var classNumber = 0;
    var widthTimes = 0;
    switch (hashValue) {
      case 'hvorn%C3%A5r':
        classNumber = 1;
        widthTimes = 0;
          break;
      case 'hvad':
        classNumber = 2;
        widthTimes = 1;
          break;
      case 'hvordan':
        classNumber = 3;
        widthTimes = 2;
          break;
      case 'hvor':
        classNumber = 4;
        widthTimes = 3;
          break;
      case 'hvem':
        classNumber = 5;
        widthTimes = 4;
          break;
      default:
    }

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
