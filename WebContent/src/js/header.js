import { gsap } from './animations';
var $ = require('jquery');

var isMobileMenuOpen = false;

const openMobileMenu = () => {
  $('body').addClass('open-menu');
  gsap.from('.mobile-menu-item', { y: 100, duration: 1 });
};

const closeMobileMenu = () => {
  $('body').removeClass('open-menu');
};

export function init() {
  $('.hamburger-button').on('click', function () {
    if (isMobileMenuOpen) {
      closeMobileMenu();
    } else {
      openMobileMenu();
    }
    isMobileMenuOpen = !isMobileMenuOpen;
  });
}
