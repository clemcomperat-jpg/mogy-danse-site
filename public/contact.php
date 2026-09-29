<?php
/**
 * MOGY DANS' CLUB — Traitement du formulaire de contact
 * Compatible hébergements mutualisés Hostinger et OVH (fonction mail() de PHP).
 *
 * ⚙ RÉGLAGES : modifiez les 3 constantes ci-dessous.
 *  - DESTINATAIRE : l'adresse qui reçoit les messages.
 *  - EXPEDITEUR   : une adresse DE VOTRE NOM DE DOMAINE (ex. contact@votre-domaine.fr),
 *                   sinon les messages risquent de finir en spam ou d'être refusés.
 */
const DESTINATAIRE = 'zago.g@orange.fr';
const EXPEDITEUR   = 'no-reply@cours-danse89.fr';
const NOM_SITE     = "MOGY DANS' CLUB";

function retour(string $etat): void {
    header('Location: contact.html?envoi=' . $etat);
    exit;
}

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    retour('erreur');
}

// Piège à robots : ce champ invisible doit rester vide
if (!empty($_POST['site_web'])) {
    retour('ok'); // on fait semblant que tout va bien
}

$nom       = trim(strip_tags($_POST['nom'] ?? ''));
$email     = trim($_POST['email'] ?? '');
$telephone = trim(strip_tags($_POST['telephone'] ?? ''));
$sujet     = trim(strip_tags($_POST['sujet'] ?? 'Contact'));
$message   = trim(strip_tags($_POST['message'] ?? ''));
$verif     = trim($_POST['verif'] ?? '');

// Validation
if ($nom === '' || mb_strlen($nom) > 100) retour('erreur');
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) retour('erreur');
if ($message === '' || mb_strlen($message) > 5000) retour('erreur');
if ($verif !== '7') retour('erreur');

// Protection contre l'injection d'en-têtes
foreach ([$nom, $email, $telephone, $sujet] as $champ) {
    if (preg_match('/[\r\n]/', $champ)) retour('erreur');
}

$objet = '=?UTF-8?B?' . base64_encode('[' . NOM_SITE . '] ' . $sujet . ' — ' . $nom) . '?=';

$corps  = "Nouveau message depuis le site " . NOM_SITE . "\n";
$corps .= str_repeat('-', 50) . "\n\n";
$corps .= "Nom       : $nom\n";
$corps .= "E-mail    : $email\n";
$corps .= "Téléphone : " . ($telephone !== '' ? $telephone : 'non renseigné') . "\n";
$corps .= "Sujet     : $sujet\n\n";
$corps .= "Message :\n$message\n";

$entetes  = "From: " . NOM_SITE . " <" . EXPEDITEUR . ">\r\n";
$entetes .= "Reply-To: $nom <$email>\r\n";
$entetes .= "MIME-Version: 1.0\r\n";
$entetes .= "Content-Type: text/plain; charset=UTF-8\r\n";
$entetes .= "Content-Transfer-Encoding: 8bit\r\n";

$envoye = @mail(DESTINATAIRE, $objet, $corps, $entetes, '-f' . EXPEDITEUR);

retour($envoye ? 'ok' : 'erreur');
