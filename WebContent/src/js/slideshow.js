import { gsap } from './animations';
import Swiper from 'swiper/swiper-bundle';
var $ = require('jquery');

export function init(selector, options, animation) {
  setTimeout(() => {
    const slideshow = new Swiper(selector, options);
    slideshow.on('slideChange', function (swiper) {
      if (animation) animation();
      else {
        setTimeout(() => {
          gsap.fromTo(`${selector} #slide-${swiper.activeIndex} .ani-item`, { y: 100, opacity: 0, autoAlpha: 0 }, { y: 0, opacity: 1, autoAlpha: 1 });
        }, 200);
      }
    });

    setTimeout(() => {
      var maxHeight = 0;
      $(selector + ' .swiper-slide').each(function () {
        maxHeight = Math.max($(this).height(), maxHeight);
      });
      $(selector + ' .swiper-slide').height(maxHeight);
    }, 200);
  }, 200);
}
