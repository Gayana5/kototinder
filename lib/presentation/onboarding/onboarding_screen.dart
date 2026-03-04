import 'dart:math' as math;

import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onCompleted});

  final Future<void> Function() onCompleted;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  final List<_OnboardingStep> _steps = const [
    _OnboardingStep(
      title: 'Свайпы и лайки',
      description: 'Листайте вправо, чтобы лайкнуть, и влево — чтобы пропустить.',
      accent: Color(0xFFFFC1CC),
    ),
    _OnboardingStep(
      title: 'Детали породы',
      description: 'Открывайте карточку котика и узнавайте характер, происхождение и факты.',
      accent: Color(0xFFB6F2E2),
    ),
    _OnboardingStep(
      title: 'Список пород',
      description: 'В отдельной вкладке собран полный список пород с быстрым поиском.',
      accent: Color(0xFFFFE2B8),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _steps.length,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final page = _controller.hasClients ? _controller.page ?? _pageIndex.toDouble() : _pageIndex.toDouble();
                      final delta = (page - index).clamp(-1.0, 1.0);
                      final rotation = delta * 0.4;
                      final scale = 1 - delta.abs() * 0.2;
                      final bob = math.sin((page + index) * math.pi) * 6;
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: step.accent.withValues(alpha: 0.35),
                              ),
                              child: Transform.translate(
                                offset: Offset(0, bob),
                                child: Transform.rotate(
                                  angle: rotation,
                                  child: Transform.scale(
                                    scale: scale,
                                    child: const Icon(
                                      Icons.pets,
                                      size: 110,
                                      color: Color(0xFF4A4A4A),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              step.title,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              step.description,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black54,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _pageIndex == _steps.length - 1
                        ? null
                        : () => _controller.animateToPage(
                              _steps.length - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            ),
                    child: const Text('Пропустить'),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      _steps.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _pageIndex == index ? 22 : 8,
                        decoration: BoxDecoration(
                          color: _pageIndex == index ? Colors.black87 : Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _pageIndex == _steps.length - 1
                        ? _finish
                        : () => _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            ),
                    child: Text(_pageIndex == _steps.length - 1 ? 'Начать' : 'Дальше'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({required this.title, required this.description, required this.accent});

  final String title;
  final String description;
  final Color accent;
}
