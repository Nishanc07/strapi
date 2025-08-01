// This is a server component by default in Next.js (13/14)
import React from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";

// Server-side fetch (automatically SSR)
const getBlogs = async () => {
  const res = await fetch(
    "http://nisha-428808545.us-east-2.elb.amazonaws.com/api/articles?populate=*",
    { cache: "no-store" }
  );
  if (!res.ok) throw new Error("Failed to fetch articles");
  return res.json();
};

const Blog = async () => {
  const response = await getBlogs();
  const articles = response.data;

  return (
    <div className="min-h-screen bg-gray-100 py-8">
      <div className="container mx-auto">
        <h1 className="text-4xl font-bold text-center mb-8 text-gray-800">
          Blogs
        </h1>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {articles.map((article) => {
            const { id, title, description, slug, publishedAt, cover } =
              article;

            const imageUrl = cover?.formats?.medium?.url || cover?.url;

            return (
              <div
                key={id}
                className="bg-white rounded-lg shadow-md overflow-hidden dark:border-2 hover:scale-105 ease-in-out duration-300"
              >
                {imageUrl && (
                  <img
                    src={`http://nisha-428808545.us-east-2.elb.amazonaws.com${imageUrl}`}
                    alt={title}
                    className="w-full h-64 object-cover"
                  />
                )}

                <div className="p-4">
                  <h2 className="text-2xl font-bold mb-2">{title}</h2>

                  <p className="mb-4">
                    {description.split(" ").length > 6
                      ? description.split(" ").slice(0, 11).join(" ") + "..."
                      : description}
                  </p>

                  <div className="text-sm mb-4">
                    <span>
                      Published on{" "}
                      {new Date(publishedAt).toLocaleDateString("en-GB", {
                        day: "2-digit",
                        month: "long",
                        year: "numeric",
                      })}
                    </span>
                  </div>

                  <Link href={`/blogpost/${slug}`}>
                    <Button className="m-2" variant="outline">
                      Read More
                    </Button>
                  </Link>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};

export default Blog;
