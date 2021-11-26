let fileInput = document.getElementById("images");
let previewImgContainer = document.getElementById("preview-img");

function previewImg() {

    if(fileInput.files.length>2){
        alert('You are only allowed to upload a maximum of 2 images!');
        return false;
    }

    previewImgContainer.innerHTML = "";

    for (i of fileInput.files) {
        let reader = new FileReader();
        let figure = document.createElement("div");
        let figCap = document.createElement("figcaption");
        figCap.innerText = "";
        figure.appendChild(figCap);
        reader.onload = () => {     
            let img = document.createElement("img");
            img.setAttribute("src", reader.result);
            figure.insertBefore(img, figCap);
        }
        previewImgContainer.appendChild(figure);
        reader.readAsDataURL(i);
    }
}