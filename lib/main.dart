
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const FurthFinancingApp());

class C {
  static const navy = Color(0xFF092A4D);
  static const navy2 = Color(0xFF164765);
  static const green = Color(0xFF16A765);
  static const greenDark = Color(0xFF078653);
  static const blue = Color(0xFF2F83F7);
  static const purple = Color(0xFF8054E8);
  static const orange = Color(0xFFFF7A32);
  static const red = Color(0xFFEF5350);
  static const bg = Color(0xFFF5F9FC);
  static const border = Color(0xFFE3ECF4);
  static const muted = Color(0xFF7A8EA3);
}

class FurthFinancingApp extends StatelessWidget {
  const FurthFinancingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Furth Financing',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: C.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: C.green,
          primary: C.green,
          secondary: C.blue,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: C.navy),
        ),
      ),
      home: const AppShell(),
    );
  }
}

enum TxType { income, expense }

class Tx {
  Tx(this.title, this.category, this.amount, this.type, this.time);
  final String title;
  final String category;
  final double amount;
  final TxType type;
  final String time;
}

class SavingGoal {
  SavingGoal(this.title, this.current, this.target, this.icon);
  final String title;
  double current;
  final double target;
  final IconData icon;

  double get progress => (current / target).clamp(0, 1);
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int tab = 0;

  final List<Tx> txs = [
    Tx('Ăn trưa tại căng tin', 'Ăn uống', 50000, TxType.expense, 'Hôm nay · 12:14'),
    Tx('Mua sách tham khảo', 'Học tập', 120000, TxType.expense, 'Hôm qua · 18:30'),
    Tx('Nhận tiền tiêu vặt', 'Thu nhập', 200000, TxType.income, '01/10/2026 · 09:21'),
    Tx('Trà sữa với bạn bè', 'Giải trí', 70000, TxType.expense, '30/09/2026 · 16:45'),
  ];

  final List<SavingGoal> goals = [
    SavingGoal('Mua tai nghe mới', 350000, 2000000, Icons.headphones_rounded),
    SavingGoal('Chuyến du lịch', 800000, 2000000, Icons.landscape_rounded),
  ];

  double get income => txs
      .where((e) => e.type == TxType.income)
      .fold(2300000, (s, e) => s + e.amount);

  double get expense => txs
      .where((e) => e.type == TxType.expense)
      .fold(1010000, (s, e) => s + e.amount);

  double get balance => 1250000;

  void addTx(Tx tx) => setState(() => txs.insert(0, tx));

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        txs: txs,
        goals: goals,
        balance: balance,
        income: income,
        expense: expense,
        onAddTx: addTx,
        onTab: (i) => setState(() => tab = i),
      ),
      TransactionsPage(txs: txs, onAddTx: addTx),
      GoalsPage(goals: goals),
      TipsPage(txs: txs, income: income, expense: expense),
      const ProjectPage(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: AppBottomNav(
        index: tab,
        onChanged: (i) => setState(() => tab = i),
      ),
    );
  }
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = const [
      (Icons.home_rounded, 'Tổng quan'),
      (Icons.receipt_long_rounded, 'Thu chi'),
      (Icons.savings_rounded, 'Tiết kiệm'),
      (Icons.lightbulb_outline_rounded, 'Gợi ý'),
      (Icons.emoji_events_outlined, 'Dự án'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: C.border)),
        boxShadow: [
          BoxShadow(
            color: Color(0x10092A4D),
            blurRadius: 18,
            offset: Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == index;
              return Expanded(
                child: InkWell(
                  onTap: () => onChanged(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 48,
                        height: 32,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFE4F7EC)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          items[i].$1,
                          size: 22,
                          color: selected ? C.greenDark : const Color(0xFF738399),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[i].$2,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                          color: selected ? C.greenDark : const Color(0xFF6F8094),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.txs,
    required this.goals,
    required this.balance,
    required this.income,
    required this.expense,
    required this.onAddTx,
    required this.onTab,
  });

  final List<Tx> txs;
  final List<SavingGoal> goals;
  final double balance;
  final double income;
  final double expense;
  final ValueChanged<Tx> onAddTx;
  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: _TopBar(onAddTx: onAddTx),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 4),
              const _GreetingHero(),
              const SizedBox(height: 12),
              _BalanceCard(balance: balance),
              const SizedBox(height: 16),
              _QuickActions(
                onTx: () => onTab(1),
                onGoal: () => onTab(2),
                onReport: () => onTab(3),
                onTips: () => onTab(3),
              ),
              const SizedBox(height: 16),
              _SummaryRow(income: income, expense: expense, saved: 350000),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 380) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: SpendingCard(txs: txs)),
                        const SizedBox(width: 10),
                        Expanded(child: GoalCard(goal: goals.first)),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      SpendingCard(txs: txs),
                      const SizedBox(height: 12),
                      GoalCard(goal: goals.first),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              _SectionTitle(
                title: 'Giao dịch gần đây',
                action: 'Xem tất cả',
                onTap: () => onTab(1),
              ),
              const SizedBox(height: 8),
              _RecentTransactions(items: txs.take(4).toList()),
            ]),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onAddTx});
  final ValueChanged<Tx> onAddTx;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF41CC80), C.green],
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.eco_rounded, color: Colors.white),
        ),
        const SizedBox(width: 9),
        const Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: C.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: -.4,
                ),
                children: [
                  TextSpan(text: 'Furth '),
                  TextSpan(
                    text: 'Financing',
                    style: TextStyle(color: C.green),
                  ),
                ],
              ),
            ),
          ),
        ),
        _CircleIcon(
          icon: Icons.notifications_none_rounded,
          showDot: true,
          onTap: () {},
        ),
        const SizedBox(width: 7),
        GestureDetector(
          onTap: () {},
          child: const CircleAvatar(
            radius: 19,
            backgroundColor: Color(0xFFEAF4FF),
            child: Icon(Icons.person_rounded, color: C.navy2),
          ),
        ),
      ],
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({
    required this.icon,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: C.border),
            ),
            child: Icon(icon, color: C.navy, size: 22),
          ),
        ),
        if (showDot)
          Positioned(
            right: 1,
            top: 0,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: C.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _GreetingHero extends StatelessWidget {
  const _GreetingHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFFF8FDFF), Color(0xFFE7FAEF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            bottom: -12,
            width: 220,
            height: 165,
            child: Opacity(
              opacity: .97,
              child: Image.asset(
                'assets/student_hero.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 18,
            right: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Chào buổi sáng ☀️',
                  style: TextStyle(
                    color: C.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Xin chào,\nMinh Anh! 👋',
                  style: TextStyle(
                    color: C.navy,
                    fontSize: 25,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.6,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Quản lý tài chính thông minh,\nkiến tạo tương lai tươi sáng!',
                  style: TextStyle(
                    color: Color(0xFF667B90),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 18,
            bottom: 14,
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: C.green,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});
  final double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 17, 16, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B8F5B), Color(0xFF08754F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3016A765),
            blurRadius: 28,
            offset: Offset(0, 12),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Số dư hiện tại',
                      style: TextStyle(
                        color: Color(0xFFE6FFF1),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 7),
                    Icon(Icons.visibility_outlined, color: Colors.white, size: 18),
                  ],
                ),
                const SizedBox(height: 7),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatMoney(balance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.8,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: Color(0xFF38BB7B),
                      child: Icon(Icons.arrow_upward_rounded, size: 13, color: Colors.white),
                    ),
                    SizedBox(width: 6),
                    Text(
                      '+12,5%',
                      style: TextStyle(
                        color: Color(0xFFC9FFE1),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'so với tháng trước',
                        style: TextStyle(
                          color: Color(0xFFE2F6EC),
                          fontSize: 11,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFF3FFF8),
              foregroundColor: C.greenDark,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chi tiết',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                ),
                SizedBox(width: 3),
                Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onTx,
    required this.onGoal,
    required this.onReport,
    required this.onTips,
  });

  final VoidCallback onTx;
  final VoidCallback onGoal;
  final VoidCallback onReport;
  final VoidCallback onTips;

  @override
  Widget build(BuildContext context) {
    final items = [
      _ActionItem('Thu chi', 'Ghi giao dịch', Icons.account_balance_wallet_rounded,
          C.green, const Color(0xFFE4F9ED), onTx),
      _ActionItem('Tiết kiệm', 'Đặt mục tiêu', Icons.savings_rounded,
          C.blue, const Color(0xFFE7F2FF), onGoal),
      _ActionItem('Báo cáo', 'Xem thống kê', Icons.bar_chart_rounded,
          C.purple, const Color(0xFFF0E9FF), onReport),
      _ActionItem('Gợi ý', 'Mẹo tài chính', Icons.lightbulb_rounded,
          Color(0xFFEFB323), const Color(0xFFFFF4D6), onTips),
    ];

    return Row(
      children: List.generate(items.length, (i) {
        final item = items[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == items.length - 1 ? 0 : 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: item.onTap,
              child: Column(
                children: [
                  Container(
                    height: 66,
                    decoration: BoxDecoration(
                      color: item.bg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Icon(item.icon, color: item.color, size: 30),
                    ),
                  ),
                  const SizedBox(height: 7),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: C.navy,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.sub,
                      style: const TextStyle(
                        color: C.muted,
                        fontSize: 9.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ActionItem {
  _ActionItem(this.title, this.sub, this.icon, this.color, this.bg, this.onTap);
  final String title;
  final String sub;
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.income,
    required this.expense,
    required this.saved,
  });

  final double income;
  final double expense;
  final double saved;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryInfo(
        'Tổng thu',
        income,
        '+8%',
        Icons.trending_up_rounded,
        C.green,
        const Color(0xFFE8F9EF),
      ),
      _SummaryInfo(
        'Tổng chi',
        expense,
        '-5%',
        Icons.south_rounded,
        C.red,
        const Color(0xFFFFEEEE),
      ),
      _SummaryInfo(
        'Đã tiết kiệm',
        saved,
        '+20%',
        Icons.groups_rounded,
        C.blue,
        const Color(0xFFE9F4FF),
      ),
    ];

    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (_, i) => _SummaryCard(info: cards[i]),
      ),
    );
  }
}

class _SummaryInfo {
  _SummaryInfo(this.title, this.value, this.change, this.icon, this.color, this.bg);
  final String title;
  final double value;
  final String change;
  final IconData icon;
  final Color color;
  final Color bg;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.info});
  final _SummaryInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: info.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(.8),
                child: Icon(info.icon, size: 17, color: info.color),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  info.title,
                  style: const TextStyle(
                    color: C.navy,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatMoney(info.value),
              style: const TextStyle(
                color: C.navy,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${info.change}  so với tháng trước',
            style: TextStyle(
              color: info.color,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingCard extends StatelessWidget {
  const SpendingCard({super.key, required this.txs});
  final List<Tx> txs;

  @override
  Widget build(BuildContext context) {
    final categories = <String, double>{
      'Ăn uống': 40,
      'Mua sắm': 25,
      'Học tập': 15,
      'Giải trí': 12,
      'Khác': 8,
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Chi tiêu tháng này'),
          const SizedBox(height: 11),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size.square(100),
                      painter: _DonutPainter(),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '1.250.000đ',
                          style: TextStyle(
                            color: C.navy,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Tổng chi',
                          style: TextStyle(color: C.muted, fontSize: 9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: categories.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: categoryColor(e.key),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              e.key,
                              style: const TextStyle(
                                color: C.navy,
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                          Text(
                            '${e.value.toInt()}%',
                            style: const TextStyle(
                              color: C.navy,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 5;
    final stroke = 14.0;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    final data = [
      (40.0, C.orange),
      (25.0, C.blue),
      (15.0, C.green),
      (12.0, C.purple),
      (8.0, const Color(0xFFB7C0CA)),
    ];

    var start = -math.pi / 2;
    for (final item in data) {
      final sweep = math.pi * 2 * item.$1 / 100;
      paint.color = item.$2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep - .035,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GoalCard extends StatelessWidget {
  const GoalCard({super.key, required this.goal});
  final SavingGoal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Mục tiêu tiết kiệm'),
          const SizedBox(height: 11),
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(goal.icon, color: C.navy, size: 31),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: const TextStyle(
                        color: C.navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${formatMoney(goal.current)} / ${formatMoney(goal.target)}',
                        style: const TextStyle(color: C.muted, fontSize: 9.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              minHeight: 8,
                              value: goal.progress,
                              backgroundColor: const Color(0xFFE8EDF2),
                              color: C.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${(goal.progress * 100).round()}%',
                          style: const TextStyle(
                            color: C.navy,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF9ED),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.eco_rounded, color: C.green, size: 19),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Bạn đang đi đúng hướng!\nCố gắng thêm một chút nữa nhé!',
                    style: TextStyle(
                      color: Color(0xFF397554),
                      fontSize: 9.5,
                      height: 1.3,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: C.green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    this.action,
    this.onTap,
  });

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: C.navy,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: -.2,
            ),
          ),
        ),
        if (action != null)
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  action!,
                  style: const TextStyle(
                    color: C.blue,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: C.blue, size: 17),
              ],
            ),
          ),
      ],
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions({required this.items});
  final List<Tx> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: C.border),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TransactionTile(item: item),
              ),
              if (i != items.length - 1)
                const Divider(height: 1, color: C.border),
            ],
          );
        }),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.item});
  final Tx item;

  @override
  Widget build(BuildContext context) {
    final inc = item.type == TxType.income;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: inc
                ? const Color(0xFFE7F8EF)
                : categoryColor(item.category).withOpacity(.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            inc ? Icons.account_balance_wallet_rounded : categoryIcon(item.category),
            color: inc ? C.green : categoryColor(item.category),
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: C.navy,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.time,
                style: const TextStyle(
                  color: C.muted,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${inc ? '+' : '-'} ${formatMoney(item.amount)}',
          style: TextStyle(
            color: inc ? const Color(0xFF0A9D4D) : const Color(0xFFE62D2D),
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 2),
        const Icon(Icons.chevron_right_rounded, color: C.muted, size: 20),
      ],
    );
  }
}

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({
    super.key,
    required this.txs,
    required this.onAddTx,
  });

  final List<Tx> txs;
  final ValueChanged<Tx> onAddTx;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PageHeader(
          title: 'Thu chi',
          action: IconButton.filled(
            onPressed: () => showTxSheet(context, onAddTx),
            icon: const Icon(Icons.add_rounded),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: txs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 9),
            itemBuilder: (_, i) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: C.border),
              ),
              child: TransactionTile(item: txs[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key, required this.goals});
  final List<SavingGoal> goals;

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _PageHeader(title: 'Tiết kiệm'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: widget.goals.map((goal) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: C.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFE9F4FF),
                          foregroundColor: C.blue,
                          child: Icon(goal.icon),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            goal.title,
                            style: const TextStyle(
                              color: C.navy,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          '${(goal.progress * 100).round()}%',
                          style: const TextStyle(
                            color: C.green,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: goal.progress,
                        backgroundColor: const Color(0xFFE8EDF2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${formatMoney(goal.current)} / ${formatMoney(goal.target)}',
                          style: const TextStyle(color: C.muted, fontSize: 12),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => setState(() {
                            goal.current =
                                math.min(goal.target, goal.current + 100000);
                          }),
                          child: const Text('+ 100.000đ'),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class TipsPage extends StatelessWidget {
  const TipsPage({
    super.key,
    required this.txs,
    required this.income,
    required this.expense,
  });

  final List<Tx> txs;
  final double income;
  final double expense;

  @override
  Widget build(BuildContext context) {
    final ratio = income <= 0 ? 0 : expense / income;
    return Column(
      children: [
        const _PageHeader(title: 'Gợi ý thông minh'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              _TipCard(
                icon: Icons.auto_awesome_rounded,
                color: C.purple,
                title: 'Trợ lý tài chính học sinh',
                text:
                    'Bạn đã dùng ${(ratio * 100).round()}% thu nhập. Hãy cố gắng giữ một phần tiền cho mục tiêu tiết kiệm.',
              ),
              const SizedBox(height: 10),
              const _TipCard(
                icon: Icons.restaurant_rounded,
                color: C.orange,
                title: 'Kiểm soát khoản nhỏ',
                text:
                    'Những khoản ăn uống và đồ uống nhỏ có thể cộng lại thành số tiền lớn. Hãy đặt giới hạn theo tuần.',
              ),
              const SizedBox(height: 10),
              const _TipCard(
                icon: Icons.savings_rounded,
                color: C.green,
                title: 'Tiết kiệm trước, chi tiêu sau',
                text:
                    'Khi nhận tiền tiêu vặt, hãy chuyển ngay một phần nhỏ vào mục tiêu tiết kiệm.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.12),
            foregroundColor: color,
            child: Icon(icon),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: C.navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: const TextStyle(
                    color: C.muted,
                    height: 1.45,
                    fontSize: 12.5,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = const [
      ('Đóng cổng hồ sơ', '23:59 ngày 02/10/2026', Icons.event_rounded),
      ('Chấm hồ sơ', '08–11/10/2026', Icons.fact_check_outlined),
      ('Thông báo kết quả', '12–13/10/2026', Icons.campaign_outlined),
      ('Vòng Khu vực', '17–18/10/2026', Icons.emoji_events_outlined),
      ('Hình thức', 'Thi trực tuyến', Icons.laptop_mac_rounded),
    ];

    return Column(
      children: [
        const _PageHeader(title: 'Dự án'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0B8F5B), C.navy2],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Furth Financing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Ứng dụng quản lý tài chính & chi tiêu cá nhân dành cho học sinh.',
                      style: TextStyle(
                        color: Color(0xFFE5F8EF),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: C.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cuộc thi Dự án Sáng tạo AI',
                      style: TextStyle(
                        color: C.navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...rows.map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 11),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFFFFF3D7),
                                foregroundColor: const Color(0xFFEBA814),
                                child: Icon(r.$3, size: 19),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  r.$1,
                                  style: const TextStyle(
                                    color: C.navy,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                r.$2,
                                style: const TextStyle(
                                  color: C.navy,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, this.action});
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: C.navy,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

Future<void> showTxSheet(
  BuildContext context,
  ValueChanged<Tx> onAdd,
) async {
  final title = TextEditingController();
  final amount = TextEditingController();
  var type = TxType.expense;
  var category = 'Ăn uống';

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              18,
              0,
              18,
              20 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thêm giao dịch',
                    style: TextStyle(
                      color: C.navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SegmentedButton<TxType>(
                    segments: const [
                      ButtonSegment(
                        value: TxType.expense,
                        label: Text('Khoản chi'),
                        icon: Icon(Icons.north_east_rounded),
                      ),
                      ButtonSegment(
                        value: TxType.income,
                        label: Text('Khoản thu'),
                        icon: Icon(Icons.south_west_rounded),
                      ),
                    ],
                    selected: {type},
                    onSelectionChanged: (v) =>
                        setSheetState(() => type = v.first),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: title,
                    decoration: _input('Nội dung', 'Ví dụ: Ăn sáng'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    decoration: _input('Số tiền', '50000').copyWith(
                      suffixText: 'đ',
                    ),
                  ),
                  if (type == TxType.expense) ...[
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: _input('Danh mục', null),
                      items: const [
                        'Ăn uống',
                        'Mua sắm',
                        'Học tập',
                        'Giải trí',
                        'Khác'
                      ]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setSheetState(() => category = v);
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final number =
                            double.tryParse(amount.text.replaceAll('.', '')) ?? 0;
                        if (title.text.trim().isEmpty || number <= 0) return;

                        onAdd(
                          Tx(
                            title.text.trim(),
                            type == TxType.income ? 'Thu nhập' : category,
                            number,
                            type,
                            'Vừa xong',
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Lưu giao dịch'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

InputDecoration _input(String label, String? hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF5F9FC),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: C.border),
    ),
  );
}

String formatMoney(double value) {
  final s = value.round().abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return '${value < 0 ? '-' : ''}${b.toString()}đ';
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'Ăn uống':
      return Icons.restaurant_rounded;
    case 'Mua sắm':
      return Icons.shopping_bag_rounded;
    case 'Học tập':
      return Icons.menu_book_rounded;
    case 'Giải trí':
      return Icons.local_drink_rounded;
    default:
      return Icons.category_rounded;
  }
}

Color categoryColor(String category) {
  switch (category) {
    case 'Ăn uống':
      return C.orange;
    case 'Mua sắm':
      return C.blue;
    case 'Học tập':
      return C.green;
    case 'Giải trí':
      return C.purple;
    default:
      return const Color(0xFFB7C0CA);
  }
}
