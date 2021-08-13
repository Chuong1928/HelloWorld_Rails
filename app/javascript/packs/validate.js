console.log(123);
function Validator(param){
    function debug_validate(element, input_valid){
        //call function check
        let errElement = input_valid.parentElement.querySelector(param.errSelector)
        let errorMes = element.check(input_valid.value)
        //console.log(errorMes);
        //console.log(input_valid.value);
        if(errorMes){
            errElement.innerText = errorMes
            input_valid.parentElement.classList.add('validator')
        }else{
            errElement.innerText = ''
            input_valid.parentElement.classList.remove('validator')
        }
        return !!errorMes;
   }

    let current_form = document.querySelector(param.form)
    if(current_form){
       
        current_form.onsubmit = function(e){
            e.preventDefault();
            let flag_check = true;
            param.rules.forEach(element => {
                let input_valid = current_form.querySelector(element.seletor);
                let status = debug_validate(element,input_valid)
                if(status){
                    flag_check = false;
                    console.log(status);
                }
            });

            if(flag_check){
                 console.log("không có lỗi");
                 alert("submit thành công");
                 current_form.submit();
                 
            }else{
                console.log("có lỗi"+ flag_check );
            }

        }

        //console.log(param);
        //each rule
        param.rules.forEach(element => {
           // console.log(element);
           let input_valid = current_form.querySelector(element.seletor);
           //console.log(input_valid);
           if(input_valid){
               //onblur event
               input_valid.onblur = function (){
                    debug_validate(element,input_valid)
               }
               //oninput event
               input_valid.oninput = function (){
                    let errElement = input_valid.parentElement.querySelector(param.errSelector)
                    errElement.innerText = ''
                    input_valid.parentElement.classList.remove('validator')
               }
           }

         
        });
    }
}

Validator.isEmail = function(seletor){
    return {
        seletor : seletor,
        check : function(email){
            let regex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
            return regex.test(email) ? undefined : 'An email address is required';
        }
    }
}
Validator.isName = function(seletor){
    return {
        seletor : seletor,
        check : function(name){
            if(name.trim())
                return undefined;
            else
                return 'An AWS account name is required.';
        }
    }
}
Validator.isPass = function(seletor){
    return {
        seletor : seletor,
        check : function(pass){
            if(pass.trim())
                return undefined;
            else
                return 'A password is required.';
        }
    }
}
Validator.isLength = function(seletor,minLength){
    return {
        seletor : seletor,
        check : function(pass){
            if(pass.length == 0) return 'A password is required.';
           return (pass.length >= minLength ) ? undefined:'Your password must have a minimum of 8 characters and a maximum of 128 characters.';
        }
    }
}

Validator.isConfirmPass = function(seletor,yourPass){
    return {
        seletor : seletor,
        check : function(pass){
            
           return pass === yourPass() ? undefined : `The passwords don't match`
        }
    }
}

Validator({
    form  : '#register-form-1',
    errSelector : ".error-mes",
    rules : [
        Validator.isEmail("#user_email"),
        Validator.isName("#user_name"),
        Validator.isPass("#user_password"),
        Validator.isLength("#user_password",8),
        Validator.isConfirmPass("#user_password_confirmation", function (){
            return document.querySelector("#register-form-1 #user_password").value;
        })
    ]
})