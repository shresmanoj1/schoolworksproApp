import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/response/digital_book_response.dart';
import '../../../api/api_response.dart';
import '../../api/repositories/library_repo.dart';
import '../../config/api_response_config.dart';
import '../../response/digital_book_mark_response.dart';
import '../../response/issuedbook_response.dart';
import '../../response/physicalbook_response.dart';
import '../../services/issuedbook_service.dart';

class LibraryViewModel extends ChangeNotifier {
  ApiResponse _allBooksApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allBooksApiResponse => _allBooksApiResponse;
  // Physicalbookresponse _allBooks = Physicalbookresponse();
  // Physicalbookresponse get allBooks => _allBooks;
  List<dynamic> _allBooks = <dynamic>[];
  List<dynamic> get allBooks => _allBooks;

  Future<void> fetchAllBooks() async {
    _allBooksApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Physicalbookresponse res = await LibraryRepository().getAllBooks("1");

      if (res.success == true) {
        _allBooks = res.books!;
        // _hasMore = res.count! > _page;
        _allBooksApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allBooksApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      // print("VM CATCH ERRe :: $e");
      _allBooksApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _digitalBookMarkedBooksApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get digitalBookMarkedBooksApiResponse =>
      _digitalBookMarkedBooksApiResponse;
  DigitalBookMarkedResponse _digitalBookMarkedBooks =
      DigitalBookMarkedResponse();
  DigitalBookMarkedResponse get digitalBookMarkedBooks =>
      _digitalBookMarkedBooks;

  Future<void> fetchDigitalBookMarkedBooks() async {
    _digitalBookMarkedBooksApiResponse = ApiResponse.initial("Empty Data");
    notifyListeners();
    try {
      DigitalBookMarkedResponse res =
          await LibraryRepository().getDigitalBookMarkedBooks();
      if (res.success == true) {
        _digitalBookMarkedBooks = res;
        _digitalBookMarkedBooksApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _digitalBookMarkedBooksApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      // print(e.toString());
      _digitalBookMarkedBooksApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _loadMoreApiResponse =
      ApiResponse.initial('Fetching device data');
  ApiResponse get loadMoreApiResponse => _loadMoreApiResponse;

  int _page = 1;
  int _totalData = 0;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  List<dynamic> _bookData = [];
  List<dynamic> get bookData => _bookData;

  Future<void> loadMore() async {
    // print("hasMore :: $_hasMore");
    if (!isLoadingOnly(_loadMoreApiResponse)) {
      _page += 1;
      _loadMoreApiResponse = ApiResponse.loading('Fetching device data');
      notifyListeners();
      try {
        // print("page :: $_page");
        Physicalbookresponse data =
            await LibraryRepository().getAllBooks(_page.toString());
        // print("api hitttT:::::::");
        _allBooks.addAll(data.books!);
        _loadMoreApiResponse = ApiResponse.completed(data.success.toString());
        notifyListeners();
      } catch (e) {
        _loadMoreApiResponse = ApiResponse.error(e.toString());
        notifyListeners();
      }
      await Future.delayed(const Duration(milliseconds: 20));
      _loadMoreApiResponse = ApiResponse.initial("Empty data");
      notifyListeners();
    }
  }

  ApiResponse _searchBookApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get searchBookApiResponse => _searchBookApiResponse;

  List<dynamic> _searchBook = <dynamic>[];
  List<dynamic> get searchBook => _searchBook;

  int _searchPage = 1;
  int get searchPage => _searchPage;

  bool _hasMoreSearch = true;
  bool get hasMoreSearch => _hasMoreSearch;

  ApiResponse _loadMoreSearchBookApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get loadMoreSearchBookApiResponse =>
      _loadMoreSearchBookApiResponse;

  Future<void> searchBooks(int index) async {
    _allBooksApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      if (index == 1) {
        ///physical
        Physicalbookresponse res = await LibraryRepository()
            .getSearchBook(_bookName, "physical", _searchPage.toString());
        if (res.success == true) {
          _allBooks.clear();
          _allBooks = res.books!;
          // print("SEARCH BOOKS::::${_allBooks}");
          _hasMoreSearch = res.books!.isNotEmpty;
          _allBooksApiResponse = ApiResponse.completed(res.success.toString());
          notifyListeners();
        } else {
          _allBooksApiResponse = ApiResponse.error(res.success.toString());
        }
      } else if (index == 0) {
        ///digital
        Physicalbookresponse res = await LibraryRepository()
            .getSearchBook(_bookName, "digital", _searchPage.toString());
        if (res.success == true) {
          _digitalBooks.clear();
          _digitalBooks = res.books!;
          _hasMoreSearch = res.books!.isNotEmpty;
          _allBooksApiResponse = ApiResponse.completed(res.success.toString());
          notifyListeners();
        } else {
          _allBooksApiResponse = ApiResponse.error(res.success.toString());
        }
      }
    } catch (e) {
      // print("VM CATCH ERRe :: $e");
      _allBooksApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  String _bookName = "";
  String get bookName => _bookName;

  updateBookName(String bookName) {
    _bookName = bookName;
    notifyListeners();

    // print(_bookName);
  }

  updateSearchPage(int value) {
    _searchPage = value;
    notifyListeners();
  }

  Future<void> loadMoreSearchBooks(int currentIndex) async {
    if (hasMoreSearch) {
      _searchPage += 1;
      _loadMoreSearchBookApiResponse =
          ApiResponse.loading('Fetching device data');
      notifyListeners();
      try {
        if (currentIndex == 1) {
          ///physical
          Physicalbookresponse res = await LibraryRepository()
              .getSearchBook(_bookName, "physical", _searchPage.toString());
          if (res.success == true) {
            Physicalbookresponse data =
                await LibraryRepository().getAllBooks(_page.toString());

            _allBooks.addAll(data.books!);
            _loadMoreSearchBookApiResponse =
                ApiResponse.completed(data.success.toString());
            notifyListeners();
          } else {
            _loadMoreSearchBookApiResponse =
                ApiResponse.error(res.success.toString());
          }
        } else if (currentIndex == 0) {
          ///digital
          Physicalbookresponse res = await LibraryRepository()
              .getSearchBook(_bookName, "digital", _searchPage.toString());
          if (res.success == true) {
            Physicalbookresponse res = await LibraryRepository()
                .getDigitalBooks(_pageDigital.toString());
            _digitalBooks.addAll(res.books!);
            // _hasMoreSearch = res.books!.isNotEmpty;
            _loadMoreSearchBookApiResponse = ApiResponse.completed(res.success);
            notifyListeners();
          } else {
            _allBooksApiResponse = ApiResponse.error(res.success.toString());
          }
        }
        notifyListeners();
      } catch (e) {
        _loadMoreSearchBookApiResponse = ApiResponse.error(e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  ApiResponse _allIssuedBooksApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allIssuedBooksApiResponse => _allIssuedBooksApiResponse;
  // Physicalbookresponse _allIssuedBooks = Physicalbookresponse();
  // Physicalbookresponse get allIssuedBooks => _allIssuedBooks;
  Issuedbookresponse _allIssuedBooks = Issuedbookresponse();
  Issuedbookresponse get allIssuedBooks => _allIssuedBooks;

  Future<void> fetchAllIssuedBooks(String username) async {
    _allIssuedBooksApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Issuedbookresponse res =
          await Issuedbookservice().getmyissuedbook(username);

      if (res.success == true) {
        _allIssuedBooks = res;
        // _hasMore = res.count! > _page;
        _allIssuedBooksApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allIssuedBooksApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      // print("VM CATCH ERRe :: $e");
      _allIssuedBooksApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _digitalBookApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get digitalBookApiResponse => _digitalBookApiResponse;
  List<dynamic> _digitalBooks = <dynamic>[];
  List<dynamic> get digitalBooks => _digitalBooks;
  int _pageDigital = 1;
  int _sizeDigital = 10;
  int _totalDataDigital = 0;
  bool _hasMoreDigital = true;
  int get pageDigital => _pageDigital;
  int get sizeDigital => _sizeDigital;
  int get totalDataDigital => _totalDataDigital;
  bool get hasMoreDigital => _hasMoreDigital;

  Future<void> fetchDigitalBooks() async {
    _digitalBookApiResponse = ApiResponse.initial("Empty Data");
    notifyListeners();
    try {
      Physicalbookresponse res =
          await LibraryRepository().getDigitalBooks(_pageDigital.toString());
      if (res.success == true) {
        _digitalBooks = [];
        _digitalBooks = res.books!;

        _pageDigital = 1;
        _hasMoreDigital = res.books!.isNotEmpty;
        _digitalBookApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _digitalBookApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print(e.toString());
      _digitalBookApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _loadMoreDigitalApiResponse = ApiResponse.initial('Empty data');
  ApiResponse get loadMoreDigitalApiResponse => _loadMoreDigitalApiResponse;

  Future<void> loadMoreDigitalBooks() async {
    if (hasMore) {
      _pageDigital += 1;
      _loadMoreDigitalApiResponse = ApiResponse.loading('Fetching device data');
      notifyListeners();
      try {
        Physicalbookresponse res =
            await LibraryRepository().getDigitalBooks(_pageDigital.toString());
        _digitalBooks.addAll(res.books!);
        _hasMoreDigital = res.books!.isNotEmpty;
        _loadMoreDigitalApiResponse = ApiResponse.completed(res.success);

        notifyListeners();
      } catch (e) {
        _loadMoreDigitalApiResponse = ApiResponse.error(e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  //generate token
  ApiResponse _generateTokenApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get generateTokenApiResponse => _generateTokenApiResponse;

  String _url = "";
  String get url => _url;

  Future<void> generateBookToken(String id) async {
    _generateTokenApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Map<String,dynamic> res = await LibraryRepository().generateToken(id);

      if (res['success'] == true) {
        _url = res['url'];

        print("URLS::::${_url}");

        _generateTokenApiResponse = ApiResponse.completed(res['success'].toString());
        notifyListeners();
      } else {
        _generateTokenApiResponse = ApiResponse.error(res['success'].toString());
      }
    } catch (e) {
      // print("VM CATCH ERRe :: $e");
      _generateTokenApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _page = 1;
    _searchPage = 1;
    _totalData = 0;
    _hasMore = true;
    _hasMoreSearch = true;
    _bookName = "";
    _pageDigital = 1;
    _totalDataDigital = 0;
    _hasMoreDigital = true;
    super.dispose();
  }
}
