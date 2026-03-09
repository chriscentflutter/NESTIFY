import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final bool enableShimmer;
  final bool enableScale;
  
  const AnimatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56,
    this.enableShimmer = true,
    this.enableScale = true,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    if (widget.enableShimmer) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enableScale) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enableScale) {
      setState(() => _isPressed = false);
    }
    widget.onPressed();
  }

  void _handleTapCancel() {
    if (widget.enableScale) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ?? theme.primaryColor;
    final txtColor = widget.textColor ?? Colors.white;

    return GestureDetector(
      onTapDown: widget.isLoading ? null : _handleTapDown,
      onTapUp: widget.isLoading ? null : _handleTapUp,
      onTapCancel: widget.isLoading ? null : _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed && widget.enableScale ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: bgColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Base button
              Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              
              // Shimmer effect
              if (widget.enableShimmer && !widget.isLoading)
                AnimatedBuilder(
                  animation: _shimmerAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          stops: [
                            _shimmerAnimation.value - 0.3,
                            _shimmerAnimation.value,
                            _shimmerAnimation.value + 0.3,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              
              // Content
              Center(
                child: widget.isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(txtColor),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, size: 20, color: txtColor),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: txtColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Gradient Animated Button
class GradientAnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final Gradient? gradient;
  final double? width;
  final double height;
  
  const GradientAnimatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.gradient,
    this.width,
    this.height = 56,
  }) : super(key: key);

  @override
  State<GradientAnimatedButton> createState() => _GradientAnimatedButtonState();
}

class _GradientAnimatedButtonState extends State<GradientAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor.withValues(alpha: 0.8),
      ],
    );

    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.isLoading
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed();
            },
      onTapCancel: widget.isLoading ? null : () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.gradient ?? defaultGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 20, color: Colors.white),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
