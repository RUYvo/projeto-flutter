import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/screens/auth/blocs/sign_in/sign_in_bloc.dart';
import 'package:food_app/screens/cart/blocs/bloc/cart_bloc.dart';
import 'package:food_app/screens/cart/blocs/bloc/cart_event.dart';
import 'package:food_app/screens/cart/views/cart_screen.dart';
import 'package:food_app/screens/home/blocs/get_food_bloc/get_food_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:food_app/screens/home/views/details.screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              scale: 15,
            ),
            const SizedBox(width: 8),
            const Text(
              "Food Delivery",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(CupertinoIcons.cart),
          ),
          IconButton(
              onPressed: () {
                context.read<SignInBloc>().add(SignOutRequired());
              },
              icon: const Icon(CupertinoIcons.arrow_right_to_line))
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(20, -1.2),
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber.shade200,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(2.7, -1.2),
            child: Container(
              height: MediaQuery.of(context).size.width / 1.3,
              width: MediaQuery.of(context).size.width / 1.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.shade400,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<GetFoodBloc, GetFoodState>(
              builder: (context, state) {
                if (state is GetFoodSucess) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 9 / 16,
                    ),
                    itemCount: state.foods.length,
                    itemBuilder: (context, int i) {
                      return _HoverableFoodItem(food: state.foods[i]);
                    },
                  );
                } else if (state is GetFoodLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Center(
                    child: Text(
                      "Erro ao carregar os dados: ${state.runtimeType}",
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverableFoodItem extends StatefulWidget {
  final Food food;
  const _HoverableFoodItem({Key? key, required this.food}) : super(key: key);

  @override
  __HoverableFoodItemState createState() => __HoverableFoodItemState();
}

class __HoverableFoodItemState extends State<_HoverableFoodItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _onHover(PointerEnterEvent event) {
    setState(() {
      _isHovered = true;
    });
    _controller.forward();
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _isHovered = false;
    });
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onHover,
      onExit: _onExit,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          elevation: _isHovered ? 5 : 3,
          color: Colors.grey.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => DetailScreen(widget.food),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      widget.food.picture,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Erro ao carregar a imagem');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      if (widget.food.followUp)
                        _buildLabel("🔥EM ALTA", Colors.red, Colors.white),
                      if (widget.food.promotion)
                        _buildLabel("🔰 PROMOÇÃO", Colors.green, Colors.green.shade100),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    widget.food.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    widget.food.description,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.food.promotion
                            ? "R\$ ${(widget.food.price - (widget.food.price * (widget.food.discount) / 100)).toStringAsFixed(2)}"
                            : "R\$ ${widget.food.price}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.read<CartBloc>().add(
                              AddToCartEvent(food: widget.food, quantity: 1),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Item adicionado ao carrinho!')),
                            );
                          });
                        },
                        icon: const Icon(CupertinoIcons.add_circled_solid),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color textColor, Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 9,
        ),
      ),
    );
  }
}
