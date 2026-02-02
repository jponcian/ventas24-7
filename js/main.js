document.addEventListener('DOMContentLoaded', () => {

    // Script del menu responsive
    const showMenu = (toggleId, navId) => {
        const toggle = document.getElementById(toggleId),
              nav = document.getElementById(navId);
        
        if(toggle && nav){
            toggle.addEventListener('click', ()=>{
                nav.classList.toggle('show');
            });

            // Cerrar menú al hacer click en un enlace
            nav.addEventListener('click', e => {
                let el = e.target;
                if(el.tagName === 'A'){
                    nav.classList.toggle('show');
                }
            });
        }
    }
    showMenu('navbar-menu-mobile','navbar-container');

    // Smooth scroll initialization
    if (typeof SmoothScroll !== 'undefined') {
        var scroll = new SmoothScroll('a[href*="#"]', {
            speed: 800,
            speedAsDuration: true,
            offset: 60 // Compensate for fixed navbar
        });
    }

});