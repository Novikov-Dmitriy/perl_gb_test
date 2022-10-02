 
function validDateForm() {
    var x = document.forms["search_form"]["address"].value;
    
    if (x == "") 
    {
        alert("Необходимо ввести адрес электронной почты");
        return false;
    }
    else
    {
        const re = /[\w|\.|-]+\@[\w|\.|-]+\.\w+/;
        if(re.test(x))
            return true;
        else
        {
            alert("Введённая информация не соответствует шаблону адреса электронной почты. Пожалуйста, проверьте адрес.");
            return false;
        }
    }
    return true;
}
