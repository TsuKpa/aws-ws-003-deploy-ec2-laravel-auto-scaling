<?php

namespace App\Http\Controllers\Frontend;

use App\Http\Controllers\Controller;
use App\Models\Blog;
use View;


class HomeController extends Controller
{

   public function index()
   {
      $latest_news = Blog::where('status', 1)->orderby('created_at', 'desc')->get();
      return View::make('frontend.index', compact('latest_news'));
   }

   // News Details
   public function viewNews(Blog $blog)
   {
      return view('frontend.newsDetails', compact('blog'));
   }


}
