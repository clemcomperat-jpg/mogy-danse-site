/* MOGY DANS' CLUB — scripts du site (aucune dépendance) */
(function () {
  "use strict";

  /* Menu mobile */
  var bouton = document.querySelector(".bouton-menu");
  var menu = document.getElementById("menu-principal");
  if (bouton && menu) {
    bouton.addEventListener("click", function () {
      var ouvert = menu.classList.toggle("ouvert");
      bouton.setAttribute("aria-expanded", ouvert ? "true" : "false");
    });
  }

  /* Année dans le pied de page */
  var annee = document.getElementById("annee");
  if (annee) annee.textContent = new Date().getFullYear();

  /* Images absentes (tant que scripts/recuperer-images.sh n'a pas été lancé) */
  document.querySelectorAll("img").forEach(function (img) {
    function marquer() {
      img.classList.add("image-absente");
      if (img.closest(".galerie")) img.parentElement.classList.add("image-absente-parent");
      if (img.closest(".logo, .ffd")) img.style.display = "none";
    }
    if (img.complete && img.naturalWidth === 0 && img.getAttribute("src")) marquer();
    img.addEventListener("error", marquer);
  });

  /* Vidéos YouTube : chargées seulement au clic (respect de la vie privée / RGPD) */
  document.querySelectorAll(".video-lancer").forEach(function (b) {
    var id = b.getAttribute("data-video");
    b.style.backgroundImage = "url(https://i.ytimg.com/vi/" + id + "/hqdefault.jpg)";
    b.addEventListener("click", function () {
      var iframe = document.createElement("iframe");
      iframe.src = "https://www.youtube-nocookie.com/embed/" + id + "?autoplay=1&rel=0";
      iframe.title = b.getAttribute("aria-label") || "Vidéo";
      iframe.allow = "autoplay; encrypted-media; picture-in-picture; fullscreen";
      iframe.allowFullscreen = true;
      b.replaceWith(iframe);
    });
  });

  /* Visionneuse de photos */
  var liens = Array.prototype.slice.call(document.querySelectorAll(".galerie a"));
  if (liens.length) {
    var v = document.createElement("div");
    v.className = "visionneuse";
    v.setAttribute("role", "dialog");
    v.setAttribute("aria-modal", "true");
    v.innerHTML =
      '<button class="fermer" aria-label="Fermer">×</button>' +
      '<button class="prec" aria-label="Photo précédente">‹</button>' +
      '<img alt="">' +
      '<button class="suiv" aria-label="Photo suivante">›</button>';
    document.body.appendChild(v);
    var grande = v.querySelector("img");
    var index = 0;

    function afficher(i) {
      index = (i + liens.length) % liens.length;
      grande.src = liens[index].getAttribute("href");
      grande.alt = (liens[index].querySelector("img") || {}).alt || "";
      v.classList.add("ouverte");
    }
    function fermer() { v.classList.remove("ouverte"); }

    liens.forEach(function (a, i) {
      a.addEventListener("click", function (e) { e.preventDefault(); afficher(i); });
    });
    v.querySelector(".fermer").addEventListener("click", fermer);
    v.querySelector(".prec").addEventListener("click", function () { afficher(index - 1); });
    v.querySelector(".suiv").addEventListener("click", function () { afficher(index + 1); });
    v.addEventListener("click", function (e) { if (e.target === v) fermer(); });
    document.addEventListener("keydown", function (e) {
      if (!v.classList.contains("ouverte")) return;
      if (e.key === "Escape") fermer();
      if (e.key === "ArrowLeft") afficher(index - 1);
      if (e.key === "ArrowRight") afficher(index + 1);
    });
  }

  /* Message de retour du formulaire de contact (?envoi=ok / ?envoi=erreur) */
  var retour = document.getElementById("retour-formulaire");
  if (retour) {
    var etat = new URLSearchParams(window.location.search).get("envoi");
    if (etat === "ok") {
      retour.className = "message-retour ok";
      retour.textContent = "Merci ! Votre message a bien été envoyé. Nous vous répondrons rapidement.";
      retour.hidden = false;
    } else if (etat === "erreur") {
      retour.className = "message-retour erreur";
      retour.textContent = "Désolé, le message n'a pas pu être envoyé. Vérifiez les champs ou appelez-nous directement.";
      retour.hidden = false;
    }
  }
})();
