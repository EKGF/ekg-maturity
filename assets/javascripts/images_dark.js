(function() {
const paletteSwitcher0 = document.getElementById("__palette_0");
const paletteSwitcher1 = document.getElementById("__palette_1");

if (paletteSwitcher0) {
    paletteSwitcher0.addEventListener("change", function () {
        documentFromDarkToLight(document)
    });
}

if (paletteSwitcher1) {
    paletteSwitcher1.addEventListener("change", function () {
        documentFromLightToDark(document)
    });
}



// if (window.matchMedia('(prefers-color-scheme: dark)').matches === true) {
//     documentFromLightToDark(document)
// }

const darkModeMediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
darkModeMediaQuery.addListener((e) => {
    const darkModeOn = e.matches;

    if (darkModeOn)
        documentFromLightToDark(document)
    else
        documentFromDarkToLight(document)
    console.log(`Dark mode is ${darkModeOn ? '🌒 on' : '☀️ off'}.`);
});

function documentFromDarkToLight(document) {
    imagesFromDarkToLight(document.querySelectorAll('img[src$="darkable"'));
    objectsFromDarkToLight(document.querySelectorAll('object[data$="darkable"'));
}

function documentFromLightToDark(document) {
    imagesFromLightToDark(document.querySelectorAll('img[src$="darkable"'));
    objectsFromLightToDark(document.querySelectorAll('object[data$="darkable"'));
}

function imagesFromLightToDark(images) {
    images.forEach(image => {
        const idx = image.src.lastIndexOf('.');
        if (idx > -1) {
            const add = "_dark";
            image.src = [image.src.slice(0, idx), add, image.src.slice(idx)].join('');
        }
    });
}

function imagesFromDarkToLight(images) {
    images.forEach(image => {
        image.src = image.src.replace("_dark", "");
    });
}

function objectsFromLightToDark(objects) {
    objects.forEach(object => {
        const idx = object.data.lastIndexOf('.');
        if (idx > -1) {
            const add = "_dark";
            object.data = [object.data.slice(0, idx), add, object.data.slice(idx)].join('');
        }
    });
}

function objectsFromDarkToLight(objects) {
    objects.forEach(object => {
        object.data = object.data.replace("_dark", "");
    });
}

})();
