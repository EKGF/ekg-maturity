const paletteSwitcher1 = document.getElementById("__palette_1");
const paletteSwitcher2 = document.getElementById("__palette_2");

paletteSwitcher1.addEventListener("change", function () {
    const darkables = document.querySelectorAll('img[src$="darkable"');
    fromDarkToLight(darkables);
});

paletteSwitcher2.addEventListener("change", function () {
    const darkables = document.querySelectorAll('img[src$="darkable"');
    fromLightToDark(darkables);
});

function fromLightToDark(images) {
    images.forEach(image => {
        const idx = image.src.lastIndexOf('.');
        if (idx > -1) {
            const add = "_dark";
            image.src = [image.src.slice(0, idx), add, image.src.slice(idx)].join('');
        }
    });
}

function fromDarkToLight(images) {
    images.forEach(image => {
        image.src = image.src.replace("_dark", "");
    });
}