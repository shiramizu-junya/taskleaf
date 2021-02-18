class TasksController < ApplicationController
  # :show, :edit, :update, :destroyのアクションで「@task = current_user.tasks.find(params[:id])」という同じ処理を書いている
  # なのでフィルタを利用してまとめてあげる。４つのアクションが実行される前に「set_task」メソッドを実行する
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # タスク一覧画面
  def index
    # allメソッドでtaksテーブルから全てのtaskモデルのオブジェクト（データ）を取得する
    # メソッドの戻り値をビューに伝えるためインスタンス変数に入れる
    # 実際はこの時点で検索は行われずTask::ActiveRecord_Relationクラスがインスタンス変数に入っている。
    # @tasksをビューで使う時に（必要になったタイミング）検索される。
    # @tasksには取得した全てのオブジェクトが配列で格納されている状態と同じ
    # @tasks = Task.all

    # Userモデルに定義した「has_many」の関連を利用して、ログインしているユーザーが登録しているタスクだけを取得する
    # 「recent」はTaskモデルに書いたscopeを使って絞り込み条件(order(created_at: :desc))をスッキリ書ける
    # @tasks = current_user.tasks.order(created_at: :desc)
    @tasks = current_user.tasks.recent
  end

  # タスク詳細画面
  def show
    # findメソッドはテーブルのid属性を使ってレコードを検索する
    # /tasks/:id の動的に変更する「:id」部分はリクエストパラメーター「params」に「:id」をキーとして格納されている。
    # @task = Task.find(params[:id])

    # URLに直接「/tasks/17」みたいに書いて検索すれば他人のタスクを見れるのでそれを防ぐ
    # @task = current_user.tasks.find(params[:id])
  end

  # タスク新規作成画面
  def new
    # ビューファイルの入力フォームとモデルクラスのオブジェクトを紐づけるためにnewしている
    @task = Task.new
  end

  # タスク編集画面
  def edit
    # URLに直接「/tasks/17/edit」みたいに書いて検索すれば他人のタスクを編集できるのでそれを防ぐ
    # @task = current_user.tasks.find(params[:id])
  end

  # 新規登録機能
  def create
    # タスクを新規登録するときにログインしているユーザーと紐ずける(ログインしているユーザーのIDも登録)
    @task = current_user.tasks.new(task_params)
    # saveメソッドを実行すると自動でバリデーションチェックしてくれる。問題無くDBへ登録・更新を行えればtrue、バリーデーションに引っかかった場合はfalseが戻り値になる。
    # さらに、falseの場合はエラーメッセージが自動でオブジェクトに入る。エラーメッセージは「オブジェクト名.errors.full_message」を通じて取得できる。
    if @task.save
      # 自分でログファイルとターミナルのサーバーログにログを出力する
      logger.debug "task: #{@task.attributes.inspect}"
      # Flashメッセージはリダイレクトの際に（ブラウザから指定のURLに通信が投げられて時）にちょっとしたデータを伝える（Cookieとセッションを使っている）
      # flash: { notice: "タスク「#{task.name}」を登録しました。" } がセットされている。（サーバー側に保存されている）
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      # バリデーションに引っかかった場合は、「new.html.slim」ファイルを返す。
      render :new
    end
  end

  def update
    # @task = current_user.tasks.find(params[:id])

    # DBに登録されているレコード１つ１つはTaskモデルをインスタンス化したオブジェクトになっている。なので「オブジェクト名.メソッド名」で実行できる
    # updateメソッドもバリデーションチェックされる
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    # @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end

  # プライベートメソッド（クラスの中からしか呼び出せないメソッド）
  private

  # フォームから送られてきたリクエストパラメーターが想定通り「 Parameters: {"utf8"=>"✓", "authenticity_token"=>"〇〇", "task"=>{"name"=>"タスク名", "description"=>"詳細"}, "commit"=>"登録する"}」であるかをチェックする
  # さらに「{"name"=>"タスク名", "description"=>"詳細"}」の部分から受け付ける想定である「:name」と「:descrption」の情報だけを抜き取る
  # これはフォームから不正な値が送信されて、モデルに入力されて登録・更新されるのを防ぐセキュリティ対策。 StrongParametersという。
  # paramsにフォームから入力された情報が入ってくる。
  # params.require(:モデル名(キー名)) ➡︎ {"name"=>"タスク名", "description"=>"詳細"} を取り出す
  # .permit(:カラム名, カラム名) ➡︎ 必要なデータ以外を除外
  # params.require(:task) => paramsにキーが「:task」があるよね？無ければ例外を出す
  # permit(:name, :description) => params[:task]から取り出していいのは「:name」と「:description」だけで、あとは無視して。情報が足りなくてもいい。
  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end


