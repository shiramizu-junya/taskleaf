require 'rails_helper'

# describe、context ➡︎ テストケースを整理・分類する
# before、it ➡︎ テストコードを実行する

# describe [仕様を記述する対象(テスト対象)], type: [Specの種類] do

#   context [ある状況・状態] do

#     before do
#       [事前準備]
#     end

#     it [仕様の内容(機体の概要)] do
#       [期待する動作]
#     end

#   end

# end

# テスト内容：一覧画面に遷移したら作成済みのタスクが表示されている
# describeは「何について仕様を記述しようとしているか？（テストの対象）」を書く。達成したい機能や処理の名称を書く。
# 1番外のdescribeにはSpecファイルの主題を書く。
describe "タスク管理機能", type: :system do

  # beforeのログインするコードでログインする人を動的に変更したい(ユーザーAでログインしたり、ユーザーBでログインしたり・・・)
  # その場合、先に処理されるbeforeより前に共通処理を書いて、「describe/context」ごとに細かい違い部分だけを定義する。
  # そんな時に使えるのが「let」です。変数のように使えるものです。
  # letは初めて呼ばれた時にブロック内が実行されます。なので呼ばれないと実行されません。必ず実行したい場合は「let!(){}」を使います。
  # let(定義名) { 定義内容 }
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
  # 作成者がユーザーAであるタスクを作成しておく(テストデータを準備)
  # ここで初めてlet(:user_a)を呼んでいるので、ユーザーAが作られてDBに登録される
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) } # tasks.rbの「:task」ファクトリを使って作成する。このタスクは「user_a」オブジェクトが登録したという紐付けをしたいのでuserオプションをつける

  # describeやcontext内にbeforeを書くと、対応するdescribeやcontextの領域内のテストコード(it)を実行する前に、beforeのブロック内のコードを実行してくれる。
  # beforeはその領域全体の「前提条件」を実現するためのコードを記述する場所
  # beforeの処理はitが実行されるたびに新たに実行される。次のitが実行されるまでにDBの状態は元に戻される
  before do
    # ユーザーAを作成しておく(テストデータを準備)
    #user_a = FactoryBot.create(:user) # FactoryBot.createメソッドの引数にusers.rbの「:user」ファクトリを指定。:userファクトリ通りの属性状態で作る
    #user_a = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') # 別のユーザー(ユーザーBなど)を扱う際を考えて、ファクトリの１部だけ変えたデータを作ることもできる

    # 「context "ユーザーAがログインしているとき"」と「context "ユーザーBがログインしているとき"」のbeforeの中身がほとんど同じ
    # describe/context内で共通する処理は、describe/contextの１つ上の階層のbeforeの中で共通化できる。

    # ユーザーでログインする(前提となるユーザーの操作)
      # Capybaraがブラウザ上での操作を行うためのメソッドを用意しているので、それを使う
      # １、ログイン画面にアクセスする
      visit login_path # visit [URL]
      # ２、メールアドレスを入力する = 「メールアドレス」という<label>タグがついた<input>要素にメールアドレスを入れる
      fill_in "メールアドレス",	with: login_user.email # fill_in "label名", with: "フォームに入力する値"
      # ３、パスワードを入力する
      fill_in "パスワード",	with: login_user.password
      # ４、「ログインする」ボタンを押す
      click_button 'ログインする' # click_button 'value属性の値'
  end

  # 「describe "一覧表示機能"」の「context "ユーザーAがログインしているとき"」のitと「describe "詳細表示機能"」の「context "ユーザーAがログインしているとき"」のitが同じ
  # itを共通化するためには「shared_examples」という仕組みがある。shared_examplesでまとめてテストケースでシェアできる。
  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  # ネストして内部のdescribeにより細かいテーマを記述する。
  describe "一覧表示機能" do

    # contextはテストの内容を「状況・状態」のバリエーションごとに分類するために使用する
    # 例えば「ユーザーの入力内容が正しいか、正しくないか」「ログインしているか、していないか」「ユーザーが管理者か、一般ユーザーか」など各種の条件を書く
    context "ユーザーAがログインしているとき" do

      # letは初めて呼ばれた時にブロック内が実行されます。なので呼ばれないと実行されません。必ず実行したい場合は「let!(){}」を使います。
      let(:login_user) { user_a }

      # describeやcontext内にbeforeを書くと、対応するdescribeやcontextの領域内のテストコードを実行する前に、beforeのブロック内のコードを実行してくれる。
      # beforeはその領域全体の「前提条件」を実現するためのコードを記述する場所
      # beforeの処理はitが実行されるたびに新たに実行される。次のitが実行されるまでにDBの状態は元に戻される
      # before do
        # ユーザーAでログインする(前提となるユーザーの操作)
        # Capybaraがブラウザ上での操作を行うためのメソッドを用意しているので、それを使う
        # １、ログイン画面にアクセスする
      #  visit login_path # visit [URL]
        # ２、メールアドレスを入力する = 「メールアドレス」という<label>タグがついた<input>要素にメールアドレスを入れる
      #  fill_in "メールアドレス",	with: "a@example.com" # fill_in "label名", with: "フォームに入力する値"
        # ３、パスワードを入力する
      #  fill_in "パスワード",	with: "password"
        # ４、「ログインする」ボタンを押す
      #  click_button 'ログインする' # click_button 'value属性の値'
      # end

      # itは期待する動作を文章とコードで記述する（ここが実際のテストケースに当たる部分）
      # itの中に書いた通りに期待する動作が行われれば、テストが１件成功したという事になる
      # it "ユーザーAが作成したタスクが表示される" do
        # 作成済みのタスクの名称が画面上に表示されていることを確認する
        # 「expect(page).to」がpage(画面)に期待するよ〇〇することを。「have_content '最初のタスク'」があるはずだよね「最初のタスク」という意味。
        # Rspecでは「have_content」の部分をマッチャという。
        # expect(page).to have_content '最初のタスク'
      # end

      # shared_examplesでまとめたitを利用する
      it_behaves_like 'ユーザーAが作成したタスクが表示される'

    end

    # 1つのdescribe("一覧表示機能")の中に複数のcontextを書くことができる
    # contextを複数記述した場合、contextの外にあるbefore(ユーザーAを作成、ユーザーAがタスクを登録)はそれぞれのcontextの内容が呼び出される前に実行される。
    context "ユーザーBがログインしているとき" do

      # letは初めて呼ばれた時にブロック内が実行されます。なので呼ばれないと実行されません。必ず実行したい場合は「let!(){}」を使います。
      let(:login_user) { user_b }

      #before do
          # ユーザーBを作成しておく
          # FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com')
          # ユーザーBでログインする
          # １、ログイン画面にアクセスする
      #   visit login_path
          # ２、メールアドレスを入力する
      #   fill_in "メールアドレス",	with: "b@example.com"
          # ３、パスワードを入力する
      #   fill_in "パスワード",	with: "password"
          # ４、「ログインする」ボタンを押す
      #   click_button 'ログインする'
      #end

      it "ユーザーAが作成したタスクが表示されない" do
        # ユーザーＡが作成したタスクの名称が画面上に表示されないことを確認する
        # 表示されていないことを期待する時は「have_no_content」というマッチャを使う
        expect(page).to have_no_content '最初のタスク'
      end

    end

  end

  describe "詳細表示機能" do

    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }

      # ログインが先なので、ログインのbeforeが先に実行される
      before do
        visit task_path(task_a)
      end

      # it "ユーザーAが作成したタスクが表示される" do
      #   expect(page).to have_content '最初のタスク'
      # end

      # shared_examplesでまとめたitを利用する
      it_behaves_like 'ユーザーAが作成したタスクが表示される'

    end

  end

  describe "新規作成機能" do

    let(:login_user) { user_a }

    before do
      visit new_task_path
      fill_in '名称', with: task_name
      click_button '登録する'
    end

    context "新規作成画面で名称を入力したとき" do

      let(:task_name) { '新規作成のテストを書く' } # デフォルトとして設定

      it "正常に登録される" do
        # have_selectorメソッド(マッチャ)は特定の要素をセレクタで指定する
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end

    end

    context "新規作成画面で名称を入力しなかったとき" do
      # 処理経路上に同じ名前のletを定義すると、常に下の階層に定義したletが使われる(上書きできる)
      let(:task_name) { '' } # 上書き

      it "エラーになる" do
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end

    end
  end
end
