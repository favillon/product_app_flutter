import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:products_app/provider/login_form_provider.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children:  [
              const SizedBox(height: 250), 

              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text('Login', style: TextStyle(fontStyle: FontStyle.normal, fontSize: 24)),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child : _LoginForm()
                    ),
                    
                  ],
                ),
              ),

              const SizedBox(height: 50),
              const Text('Crea una nueva cuenta'),
              const SizedBox(height: 50),
            ],
          ),
        )
      )
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      padding: const EdgeInsets.all(2),
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authDecoration(
                hintText: 'exampl@example.com',
                labelText: 'Email',
                prefixIcon: Icons.alternate_email_sharp
              ),
              onChanged: (value) {
                loginForm.email = value;
              },
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'email erroneo';
              }
            ),

            const SizedBox( height: 30),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authDecoration(
                hintText: '*********',
                labelText: 'Password',
                prefixIcon: Icons.lock_outline               
              ),
              onChanged: (value) {
                loginForm.pass = value;
              },
              validator: (value) {
                return (value != null && value.length >= 8) ? null  :  'password short';
              }
            ),

            const SizedBox( height: 30),

            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              disabledColor: Colors.grey,
              elevation: 1,
              color: Colors.deepPurple,
              onPressed: loginForm.isLoading ? null : () async{
                  FocusScope.of(context).unfocus();

                if ( !loginForm.isValidForm() ) return;
                
                loginForm.isLoading = true;

                await Future.delayed(const Duration(seconds: 3));

                Navigator.pushReplacementNamed(context, 'home');
              },
              child: Container(
                padding: const EdgeInsets.symmetric( vertical: 15, horizontal: 80,),
                child: Text(
                  loginForm.isLoading ? 'Cargando...' : 'Ingresar',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}