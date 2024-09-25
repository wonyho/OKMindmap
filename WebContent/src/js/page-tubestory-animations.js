import { gsap } from './animations';
var $ = require('jquery');

export function init() {
  var sections = {};
  $('.ani-sections').each(function () {
    let id = $(this).attr('id');
    sections[id] = gsap.timeline({
      scrollTrigger: {
        trigger: '#' + id,
        start: 'top 85%',
      },
    });
  });

  sections['s2'].from('#s2 .ani-item', { y: 100 });
  sections['s3'].from('#s3 .ani-item', { y: 100 });
  
  sections['s4'].from('#s4 .ani-item', { y: 100 });
  sections['s4-video'].from('#s4-video .ani-item', { scale: 0.8 });
  
  sections['s5'].from('#s5 .ani-item', { y: 100 });
  sections['s5-blocks'].from('#s5-blocks .ani-item', { y: 100 });
  sections['s5-table'].from('#s5-table .ani-item', { scale: 0.8 });
  
  sections['s6'].from('#s6 .ani-item', { y: 100 });

  sections['s7'].from('#s7 .ani-title', { y: 100 }).from('#s7 .ani-form', { scale: 0.8 });

  sections['footer'].from('#footer .ani-item', { scale: 0.8 });
}
