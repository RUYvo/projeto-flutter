import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/components/macro.dart';
import 'package:food_app/screens/cart/blocs/bloc/cart_bloc.dart';
import 'package:food_app/screens/cart/blocs/bloc/cart_event.dart';
import 'package:food_repository/food_repository.dart';

class DetailScreen extends StatefulWidget {
  final Food food;
  const DetailScreen(this.food, {super.key});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(seconds: 1),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.orangeAccent, Colors.yellowAccent],
                ),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(1.6, -1.4),
            child: Container(
              height: MediaQuery.of(context).size.width * 1.2,
              width: MediaQuery.of(context).size.width * 1.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber.shade200,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-1.3, -1.8),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.shade200,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(widget.food.picture),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(3, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.food.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (widget.food.promotion)
                                        Row(
                                          children: [
                                            Text(
                                              "R\$ ${(widget.food.price - (widget.food.price * (widget.food.discount) / 100)).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(context).colorScheme.primary,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "R\$ ${widget.food.price}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w700,
                                                  decoration: TextDecoration.lineThrough),
                                            )
                                          ],
                                        )
                                      else
                                        Text(
                                          "R\$ ${widget.food.price}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              MyMacroWidget(
                                title: "Preço de entrega:",
                                value: widget.food.macros.delivery.toInt(),
                                icon: FontAwesomeIcons.motorcycle,
                              ),
                              const SizedBox(width: 10),
                              MyMacroWidget(
                                title: "Tempo de entrega:",
                                value: widget.food.macros.time.toInt(),
                                icon: FontAwesomeIcons.clock,
                              ),
                              const SizedBox(width: 10),
                              MyMacroWidget(
                                title: "Avaliação:",
                                value: widget.food.macros.rating.toInt(),
                                icon: FontAwesomeIcons.star,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    final quantityController = TextEditingController();
                                    return AlertDialog(
                                      title: const Text("Selecione a quantidade"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text("Digite a quantidade desejada:"),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: quantityController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            final enteredQuantity = int.tryParse(quantityController.text);
                                            if (enteredQuantity != null && enteredQuantity > 0) {
                                              Navigator.pop(context);
                                              context.read<CartBloc>().add(
                                                AddToCartEvent(
                                                  food: widget.food,
                                                  quantity: enteredQuantity,
                                                ),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Adicionado $enteredQuantity ao carrinho!'),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Digite uma quantidade válida!'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                elevation: 3.0,
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Compre já!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
