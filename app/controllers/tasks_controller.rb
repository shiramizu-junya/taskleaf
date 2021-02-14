class TasksController < ApplicationController
  # タスク一覧画面
  def index
    # allメソッドでtaksテーブルから全てのtaskモデルのオブジェクト（データ）を取得する
    # メソッドの戻り値をビューに伝えるためインスタンス変数に入れる
    # 実際はこの時点で検索は行われずTask::ActiveRecord_Relationクラスがインスタンス変数に入っている。
    # @tasksをビューで使う時に（必要になったタイミング）検索される。
    # @tasksには取得した全てのオブジェクトが配列で格納されている状態と同じ
    @tasks = Task.all
  end

  # タスク詳細画面
  def show
    # findメソッドはテーブルのid属性を使ってレコードを検索する
    # /tasks/:id の動的に変更する「:id」部分はリクエストパラメーター「params」に「:id」をキーとして格納されている。
    @task = Task.find(params[:id])
  end

  # タスク新規作成画面
  def new
    # ビューファイルの入力フォームとモデルクラスのオブジェクトを紐づけるためにnewしている
    @task = Task.new
  end

  # タスク編集画面
  def edit
    @task = Task.find(params[:id])
  end

  # 新規登録機能
  def create
    task = Task.new(task_params) # 引数はメソッドを呼び出している
    # save!メソッドは保存を失敗した場合に例外を返します。つまり、save!を使えば例外をトリガーにしてロールバックなどの処理を行うことができるため、比較的使用頻度が高い
    task.save!
    # Flashメッセージはリダイレクトの際に（ブラウザから指定のURLに通信が投げられて時）にちょっとしたデータを伝える（Cookieとセッションを使っている）
    # flash: { notice: "タスク「#{task.name}」を登録しました。" } がセットされている。（サーバー側に保存されている）
    redirect_to tasks_path, notice: "タスク「#{task.name}」を登録しました。"
  end

  def update
    task = Task.find(params[:id])
    # DBに登録されているレコード１つ１つはTaskモデルをインスタンス化したオブジェクトになっている。なので「オブジェクト名.メソッド名」で実行できる
    task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{task.name}」を更新しました。"
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除しました。"
  end

  # プライベートメソッド（クラスの中からしか呼び出せないメソッド）
  private

  # フォームから送られてきたリクエストパラメーターが想定通り「 Parameters: {"utf8"=>"✓", "authenticity_token"=>"〇〇", "task"=>{"name"=>"タスク名", "description"=>"詳細"}, "commit"=>"登録する"}」であるかをチェックする
  # さらに「{"name"=>"タスク名", "description"=>"詳細"}」の部分から受け付ける想定である「:name」と「:descrption」の情報だけを抜き取る
  # これはフォームから不正な値が送信されて、モデルに入力されて登録・更新されるのを防ぐセキュリティ対策。 StrongParametersという。
  # paramsにフォームから入力された情報が入ってくる。
  # params.require(:モデル名) ➡︎ {"name"=>"タスク名", "description"=>"詳細"} を取り出す
  # .permit(:カラム名, カラム名) ➡︎ 必要なデータ以外を除外
  def task_params
    params.require(:task).permit(:name, :description)
  end
end


