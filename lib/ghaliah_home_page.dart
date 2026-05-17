import 'package:api/controller.dart';
import 'package:api/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GhaliahHomepage extends StatefulWidget {
  const GhaliahHomepage({super.key});

  @override
  State<GhaliahHomepage> createState() => _GhaliahHomepageState();
}

class _GhaliahHomepageState extends State<GhaliahHomepage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 4;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DigimonController>().fetchDigimon(context);
      }
    });

    _searchFocusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isSearchFocused = _searchFocusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final digimonController = context.watch<DigimonController>();

    // The list in state is directly fetched/filtered via API
    final filteredList = digimonController.digimonList;

    // Pagination calculations
    final totalItems = filteredList.length;
    final totalPages = (totalItems / _itemsPerPage).ceil();
    final safePage = _currentPage.clamp(1, totalPages > 0 ? totalPages : 1);

    final startIndex = (safePage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, totalItems);

    final paginatedList = totalItems > 0
        ? filteredList.sublist(startIndex, endIndex)
        : <DigimonModel>[];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Title Header
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 8),
              child: Text(
                'DIGIMON',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF8BA629),
                  letterSpacing: 4,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar & Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F3FC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isSearchFocused
                              ? const Color(0xFF29B6F6)
                              : const Color(0xFFEF5350),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.trim();
                          });
                        },
                        onSubmitted: (value) {
                          final query = value.trim();
                          if (query.isNotEmpty) {
                            digimonController.fetchDigimonByName(
                              context,
                              query,
                            );
                          } else {
                            digimonController.fetchDigimon(context);
                          }
                          setState(() {
                            _currentPage = 1;
                          });
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'DIGIMON NAME',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                      _currentPage = 1;
                                    });
                                    digimonController.fetchDigimon(context);
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Search Button (API-based Search)
                  GestureDetector(
                    onTap: () {
                      if (_searchQuery.isNotEmpty) {
                        digimonController.fetchDigimonByName(
                          context,
                          _searchQuery,
                        );
                      } else {
                        digimonController.fetchDigimon(context);
                      }
                      setState(() {
                        _currentPage = 1;
                      });
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isSearchFocused
                              ? const Color(0xFF29B6F6)
                              : const Color(0xFFEF5350),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.search,
                        color: _isSearchFocused
                            ? const Color(0xFF29B6F6)
                            : const Color(0xFFC0A272),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button (API-based Level Filter)
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isSearchFocused
                            ? const Color(0xFF29B6F6)
                            : const Color(0xFFEF5350),
                        width: 2,
                      ),
                    ),
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.filter_list,
                        color: _isSearchFocused
                            ? const Color(0xFF29B6F6)
                            : const Color(0xFFC0A272),
                      ),
                      tooltip: 'Filter by Level',
                      onSelected: (String level) {
                        if (level == 'All') {
                          digimonController.fetchDigimon(context);
                        } else {
                          digimonController.fetchDigimonByLevel(context, level);
                        }
                        setState(() {
                          _currentPage = 1;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          'All',
                          'Fresh',
                          'In Training',
                          'Rookie',
                          'Champion',
                          'Ultimate',
                          'Mega',
                        ].map((String lvl) {
                          return PopupMenuItem<String>(
                            value: lvl,
                            child: Text(
                              lvl,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Digimon List
            Expanded(
              child: digimonController.loader
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF8BA629),
                      ),
                    )
                  : paginatedList.isEmpty
                  ? const Center(
                      child: Text(
                        'No Digimon found',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: paginatedList.length,
                      itemBuilder: (context, index) {
                        final digimon = paginatedList[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              digimon.isTapped = !digimon.isTapped;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 16,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: digimon.isTapped
                                    ? const Color(0xFFEF5350)
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: digimon.isTapped
                                      ? const Color(0xFFEF5350).withOpacity(0.6)
                                      : const Color(
                                          0xFF8BA629,
                                        ).withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                  offset: const Offset(
                                    0,
                                    10,
                                  ), // Shadow is offset downwards
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  digimon.name.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Image.network(
                                  digimon.img,
                                  height: 160,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox(
                                        height: 160,
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  digimon.level.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Pagination Control Bar
            if (totalPages > 1)
              Container(
                margin: const EdgeInsets.only(bottom: 24, top: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: safePage > 1
                          ? () {
                              setState(() {
                                _currentPage = safePage - 1;
                              });
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          '←',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: safePage > 1
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '$safePage',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    InkWell(
                      onTap: safePage < totalPages
                          ? () {
                              setState(() {
                                _currentPage = safePage + 1;
                              });
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          '→',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: safePage < totalPages
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
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
