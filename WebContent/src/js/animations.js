import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

gsap.defaults({
  ease: 'expo.out',
  duration: 1,
  stagger: 0.2,
  autoAlpha: 0,
});

export { gsap };
