# Dynalist

Dynalist is outlining app. there can write as tree structure and simply to control your ideas.

This is dynalist api client gem. support dynalist api version 1. [Api document](https://apidocs.dynalist.io/)

## Installation


```ruby
gem 'dynalist'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynalist

## Usage

### setup

### File-level Api

#### Access to file information

File information store FileTree class. FileTree find file to use find_by, where.

```
# Get files information.
FileApiClient.get_files

document = FileTree.where(title: 'document')
# => [#<Document: ... title: 'document'>]

folder = FileTree.find_by(title: 'diary')
# => [#<Folder: ... title: 'diary'>]
```

#### Update files

Edit query update document or folder title.
Move query change to file move down parent folder.

Update succeeded when return true, and failed return false.

```
queries = [
    FileApiClient::Edit.new(document, 'new_doument_title'),
    FileApiClient::Move.new(document, folder)
  ]

FileApiClient.new.move_file(queries)
# => [true, true]
```

### Document-level Api

#### Get information

Document information access read method, and stored NodeTree class. NodeTree have find_by and where class.

```
NodeApiClient.new.read(document)
nodes = NodeTree.where(context: ['context01', 'some message'])
```

### Check update

Check document update versions.

```
NodeApiClient.new.check_updates([document])
# => [document_id_01: 12, document_id_02: 32]
```

### Update document

Support Insert, Move, Edit, Delete queries.
Return new node ids.

```
insert_node = Node.new(context: 'new message')

queries = [
  NodeApiClient::Insert.new(root_node, insert_node),
  NodeApiClient::Move.new(root_node, move_node),
  NodeApiClient::Edit.new(edit_node),
  NodeApiClient::Delete.new(delete_node)
]

NodeApiClient.new.edit(document, queries)
# => ['insert_node_id']
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/4geru/dynalist. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dynalist project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/4geru/dynalist/blob/master/CODE_OF_CONDUCT.md).
