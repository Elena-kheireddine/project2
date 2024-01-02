import 'package:flutter/material.dart';
import 'products.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controller = TextEditingController();
  String _text = 'project2';
  bool _load = false;

  void update(bool success) {
    setState(() {
      _load = true;
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }

  @override
  void initState() {
    updateProducts(update);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void openProducts() {
      int text = int.parse(_controller.text);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Products())
      );
      if(text != _text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong password')));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(width: 200, child: TextFormField(controller: _controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter password',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }

                return null;
              },
            )),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: openProducts,
                child: const Text('login', style: TextStyle(fontSize: 18.0),))
          ],
        ),
      ),
    );
  }
}
