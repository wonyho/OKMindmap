import AlpineI18n from 'alpinejs-i18n';
import Alpine from 'alpinejs';

let locale = window.localStorage.getItem('lang') || 'ko';

window.document.addEventListener('alpine-i18n:ready', function () {
  window.AlpineI18n.create(locale, {
    en: require('../lang/en').messages,
    ko: require('../lang/ko').messages,
    vi: require('../lang/vi').messages,
  });
});
window.document.addEventListener('alpine-i18n:locale-change', function () {
  window.localStorage.setItem('lang', window.AlpineI18n.locale);
});
Alpine.plugin(AlpineI18n);

Alpine.data('contact', require('./contact').default);

Alpine.start();
window.Alpine = Alpine;

window.$ = window.jQuery = require('jquery');
var header = require('./header');
var slideshow = require('./slideshow');

$(function () {
  header.init();
  slideshow.init('#heading-swiper', {
    speed: 1000,
    autoplay: {
      delay: 4000,
    },
    navigation: {
      nextEl: '.swiper-next',
      prevEl: '.swiper-prev',
    },
    pagination: {
      el: '.swiper-pagination',
      type: 'bullets',
      clickable: true,
    },
  });

  let pageAnimations = null;
  let bodyClass = $('body').attr('class').split(/\s+/);
  let pages = ['index', 'consulting', 'tubelearn', 'tubeanaly', 'tubestory'];

  for (let i = 0; i < pages.length; i++) {
    const p = pages[i];
    if (bodyClass.indexOf(`page-${p}`) >= 0) {
      pageAnimations = require(`./page-${p}-animations`);
      break;
    }
  }

  if (pageAnimations) {
    pageAnimations.init();
  }
});
