"use client";
import React, { useState, useEffect } from "react";
import MarkdownHTML from "@/components/MarkdownHTML";
import Link from "next/link";

export default function Page({ params }) {
  const { slug } = params;
  const [response, setBlog] = useState(null);
  const [postResponse, setPost] = useState(null);

  // Fetch blog data by slug
  const fetchData = async () => {
    const url = `http://nisha-428808545.us-east-2.elb.amazonaws.com/api/articles?filters[slug][$eq]=${slug}&populate=*`;
    const res = await fetch(url, { cache: "no-store" });
    const json = await res.json();
    setBlog(json);

    if (json?.data?.[0]?.title) {
      document.title = `${json.data[0].title} | Nisha's Developer Portfolio`;
    }
  };

  // Fetch all posts
  const fetchPosts = async () => {
    const url = `http://nisha-428808545.us-east-2.elb.amazonaws.com/api/articles?populate=*`;
    const res = await fetch(url, { cache: "no-store" });
    const json = await res.json();
    setPost(json);
  };

  useEffect(() => {
    fetchData();
    fetchPosts();
  }, [slug]);

  const blog = response?.data?.[0];

  return (
    <div className="min-h-screen bg-gray-100 py-10">
      <div className="container mx-auto px-4">
        {/* Blog Title */}
        <h1 className="text-4xl font-bold text-gray-800 mb-4 text-center cursor-default">
          {blog?.title}
        </h1>

        {/* Author and Date */}
        <div className="flex justify-center items-center text-gray-600 mb-8 cursor-default">
          <div className="text-center">
            {blog?.author?.name && (
              <p className="font-medium">Written by {blog.author.name}</p>
            )}
            <p>
              Published on{" "}
              {new Date(blog?.publishedAt).toLocaleDateString("en-GB", {
                day: "2-digit",
                month: "long",
                year: "numeric",
              })}
            </p>
          </div>
        </div>

        {/* Blog Content */}
        <div className="bg-white p-6 rounded-lg shadow-lg">
          {blog?.blocks?.map((item) => {
            switch (item["__component"]) {
              case "shared.rich-text":
                return <MarkdownHTML markdown={item.body} key={item.id} />;

              case "shared.quote":
                return (
                  <blockquote
                    className="my-4 italic text-gray-700"
                    key={item.id}
                  >
                    <p className="mb-2">"{item.body}"</p>
                    <cite className="block text-right">— {item.title}</cite>
                  </blockquote>
                );

              case "shared.slider":
                return (
                  <div key={item.id} className="my-4 bg-gray-200 p-4">
                    <p>Slider content goes here</p>
                  </div>
                );

              default:
                return null;
            }
          })}
        </div>

        {/* Related Posts Section */}
        <div className="mt-10">
          <h2 className="text-2xl font-semibold text-gray-800 mb-4">
            Related Posts
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {postResponse?.data?.map((post) => (
              <Link href={`/blogpost/${post.slug}`} key={post.id}>
                <div className="bg-white p-4 rounded-lg shadow-lg hover:shadow-xl transition duration-300 cursor-pointer hover:scale-105 ease-in-out">
                  <h3 className="text-lg font-semibold text-gray-900">
                    {post.title}
                  </h3>
                  <p className="text-gray-600 mt-2">
                    {post.description.split(" ").length > 6
                      ? post.description.split(" ").slice(0, 11).join(" ") +
                        "..."
                      : post.description}
                  </p>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
