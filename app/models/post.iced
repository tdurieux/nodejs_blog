Base   = require "./base"
{trim} = require "../../lib/utils"

class Post extends Base
  @name: "Post"

  @config:
    urlid:
      type: String
      index: unique: true
    title: String
    body: String
    tags: String
    date: Date

  @statics:
    postsByDate: (num, cb) =>
      @Store.find().sort('-date').limit(num).exec cb

    tags: (autocb) =>
      await @Store.find().select('tags').exec defer err, tags
      return err if err
      return unless tags

      filtered_tags = for tag in tags when tag.tags
        tag2 for tag2 in (tag.tags.split ',') when (tag2 = (trim tag2).toUpperCase()) and tag2 not in filtered_tags

    postsByTag: (tag, autocb) =>
      tag = new RegExp(tag, 'i') unless tag instanceof RegExp

      await @Store.where('tags', tag).sort('-date').exec defer err, posts
      return err if err
      posts

    postsByKeyword: (keyword) =>
      keyword = new RegExp(keyword, 'i') unless keyword instanceof RegExp

      filter = $or: [
        {title: keyword}
        {body:  keyword}
      ]

      await @Store.find(filter).sort('-date').exec defer err, posts
      return err if err
      posts




module.exports = Post