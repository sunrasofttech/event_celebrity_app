import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobi_user/Bloc/NotificationBloc/NotificationCubit.dart';
import 'package:mobi_user/Bloc/NotificationBloc/NotificationModel.dart';
import 'package:mobi_user/Bloc/NotificationBloc/NotificationState.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/MainColor.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final PagingController<int, Datum> _pagingController = PagingController(firstPageKey: 0);
  int pageSize = 40;

  Future<void> _fetchPage(int pageKey) async {
    log("Pagination Start Here");

    var state = context.read<NotificationCubit>().state;
    if (state is LoadedState) {
      try {
        final isLastPage = state.model.data!.length < pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(state.model.data!);
        } else {
          final nextPageKey = pageKey + state.model.data!.length;
          _pagingController.appendPage(state.model.data!, nextPageKey.toInt());
        }
      } catch (error) {
        _pagingController.error = error;
      }
    }
  }

  @override
  void initState() {
    log("Pagination Start Here");
    context.read<NotificationCubit>().getNotification(_pagingController.firstPageKey, pageSize);
    _pagingController.addPageRequestListener((pageKey) {
      log("Hi");
      _fetchPage(pageKey);
    });
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(child: CircularProgressIndicator(color: whiteColor));
          }

          if (state is ErrorState) {
            return Center(child: Text(state.error));
          }

          if (state is LoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                _pagingController.refresh();
              },
              child: PagedListView<int, Datum>(
                pagingController: _pagingController,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) {
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: whiteColor,
                          child: Icon(Icons.notifications_active, color: blackColor),
                        ),
                        title: Text("${item.title ?? "-"}", style: blackStyle),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${item.message ?? "-"}", style: blackStyle),
                            Text("${item.date ?? "-"}", style: blackStyle),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
