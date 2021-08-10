//
//  feedUploadModel.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/05.
//

import Foundation


class FeedUploadModel{
    // MARK: Img Upload
    func buildBody(feedModel: FeedModel) -> Data? {
        // 파일을 읽을 수 없다면 nil을 리턴
        guard let filedata = try? Data(contentsOf: feedModel.imageURL!) else {
            return nil
        }
        
        // 바운더리 값을 정하고,
        // 각 파트의 헤더가 될 라인들을 배열로 만든다.
        // 이 배열을 \r\n 으로 조인하여 한 덩어리로 만들어서
        // 데이터로 인코딩한다.
        let boundary = "XXXXX"
        let mimetype = "image/png"
        let headerLines = ["--\(boundary)",
            "Content-Disposition: form-data; name=\"file\"; filename=\"\(feedModel.imageURL!.lastPathComponent)\"",
            "Content-Type: \(mimetype)",
            "\r\n"]
        var data = headerLines.joined(separator:"\r\n").data(using:.utf8)!
        
        // 그 다음에 파일 데이터를 붙이고
        data.append(contentsOf: filedata)
        data.append(contentsOf: "\r\n".data(using: .utf8)!)
        
        let lines2 = ["--\(boundary)","Content-Disposition: form-data; name=\"fContent\"\r\n","\(feedModel.fContent)\r\n"]
        data.append(contentsOf: lines2.joined(separator: "\r\n").data(using: .utf8)!)
        
        let lines3 = ["--\(boundary)","Content-Disposition: form-data; name=\"fWriter\"\r\n","\(feedModel.fWriter)\r\n"]
        data.append(contentsOf: lines3.joined(separator: "\r\n").data(using: .utf8)!)
        
        let lines4 = ["--\(boundary)","Content-Disposition: form-data; name=\"fHashTag\"\r\n","\(feedModel.fHashTag)\r\n"]
        data.append(contentsOf: lines4.joined(separator: "\r\n").data(using: .utf8)!)
        
        // 마지막으로 데이터의 끝임을 알리는 바운더리를 한 번 더 사용한다.
        // 이는 '새로운 개행'이 필요하므로 앞에 \r\n이 있어야 함에 유의 한다.
        data.append(contentsOf: "\r\n--\(boundary)--".data(using:.utf8)!)
        return data
    }

    func uploadImageFile(feedModel: FeedModel, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) {
        
        // 경로를 준비하고
        //let url = URL(string: "\(filepath), ImageUpload.jsp")!
        
        let url = URL(string: "http://\(Common.ipAddr):8080/dogtor_temp/feed_insert.jsp")!

        // 경로로부터 요청을 생성한다. 이 때 Content-Type 헤더 필드를 변경한다.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\"XXXXX\"",
                         forHTTPHeaderField: "Content-Type")
        
        // 파일URL로부터 multipart 데이터를 생성하고 업로드한다.
        if let data = buildBody(feedModel: feedModel) {
            let task = URLSession.shared.uploadTask(with: request, from: data){data, res, error in
                print("--------------------------------------------------")
                if let returnData = String(data: data!, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    print("returnData : \(returnData)")
                } else {
                    print("data is empty")
                }
                print("--------------------------------------------------")
                print(res ?? "none res")
                print("--------------------------------------------------")
                print(error ?? "none error")
                print("--------------------------------------------------")
                
                if error != nil {
                    print("upload error")
                    return
                }
                
                completionHandler(data, res, error)
            }
            
            task.resume()
        }
    }
}
