window.onload=function() {
    if (document.location.hash) {
        document.location = document.location;
        console.log('xslt trick: reload hash location ');
    }
};
