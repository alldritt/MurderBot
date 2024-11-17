//
//  ContentProvider.swift
//  MurderBotTopShelf
//
//  Created by Mark Alldritt on 2023-11-08.
//

import TVServices

class ContentProvider: TVTopShelfContentProvider {

    override func loadTopShelfContent(completionHandler: @escaping (TVTopShelfContent?) -> Void) {
        // Fetch content and call completionHandler
        completionHandler(nil);
    }

}

