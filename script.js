$(document).ready(function () {

    // --- Gestione dei bottoni per i fenomeni notevoli  ---
    $('.phenomenon-btn').on('click', function () {
        var button = $(this);
        var entityClass = button.data('entity-class');
        $('.entity.' + entityClass).toggleClass('highlight');
        button.toggleClass('active-btn');
    });

    // --- Gestione del bottone per le abbreviazioni ---
    $('#toggle-abbr').on('click', function () {
        var button = $(this);
        var abbrSpans = $('.abbreviation .abbr');
        var expanSpans = $('.abbreviation .expan');

        abbrSpans.toggle();
        expanSpans.toggle();

        button.text(abbrSpans.is(':visible') ? 'Mostra Espansioni' : 'Mostra Abbreviazioni');
        button.toggleClass('active-btn');
    });

    // --- Gestione dell'evidenziazione al cambio di hash ---

    // Funzione per evidenziare il target dell'hash corrente
    function highlightTarget() {
        // Rimuovi eventuali evidenziazioni precedenti da altre righe
        $('.line-anchor.highlight-yellow').removeClass('highlight-yellow');

        // Controlla se c'è un hash nell'URL
        if (window.location.hash) {
            // window.location.hash restituisce l'hash con il # (es. "#riga1_castellammare")
            var targetId = window.location.hash;

            // Seleziona l'elemento con quell'ID e aggiungi la classe per l'evidenziazione
            $(targetId).addClass('highlight-yellow');
        }
    }

    // Aggiungi un evento che si attiva ogni volta che l'hash nell'URL cambia
    // (cioè, ogni volta che si clicca su un link <area>)
    $(window).on('hashchange', function () {
        highlightTarget();
    });

    // Esegui la funzione anche al caricamento della pagina,
    // nel caso in cui la pagina venga caricata con un hash già presente nell'URL
    highlightTarget();

});